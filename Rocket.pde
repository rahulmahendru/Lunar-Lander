/*
  A simple rocket class, operating in a vacuum (no friction)
 but with gravity pulling it down.
 Edited by Rahul Mahendru and Chris Cai
 */

class Rocket {

  //Declaration of variables
  int horVel;
  int verVel;  // to display the horizontal and vertical velocities
  int fuel; // to calculate the fuel
  float fuelConsumed; 
  int fuelDisp; // To display fuel subject ot various conditions
  int powerCheck; //To count the time for power failure
  int landCheck; // To check succesful landing
  int rx, rw; //For the flag
  float rl; 
  int[] starX = new int[500];
  int[] starY = new int[500]; 
  color[] starClr = new color[500]; //Variables to store star locations and color
  int starSz; // the size of the twinkling stars
  PImage img; // image of blast
  int checkCrash; // to check when the rocket crashes and display the blast

  //Initializing the variable sof the class
  Rocket(int startX, int startY) {
    x = startX;
    y = startY;
    horVel=0;
    verVel=0;
    fuel=1001;
    fuelConsumed=0;
    fuelDisp=0;
    powerCheck=480;
    landCheck=0;
    rx=405;
    rw=15;
    rl=.71;
    for (int i = 0; i < starX.length; i++) {
      starX[i] =(int)random(width);
      starY[i] = (int)random(height);
      starClr[i] = color((int)random(100, 255));
    }
    starSz=3;
    img=loadImage("Animated-explosion-clipart-kid.png");
    checkCrash=0;
  }

  /**
   Decrease the thrust by the specified amount where decreasing by 100 will
   immediately reduce thrust to zero.
   */
  void setThrust(int amount) {
    amount = constrain(amount, 0, 100);
    thrust = MAX_THRUST*amount/100;
    if (thrust < 0) thrust = 0;
    if (fuel<=0)
      thrust=0;
  }

  /**
   Rotate the rocket positive means right or clockwise, negative means
   left or counter clockwise.
   */
  void rotateRocket(int amt) {
    if (fuel<=0 || y>=485 || y<=30 || x<=10 || x>width-10)
      tilt+=0;
    else
      tilt = tilt + amt*TILT_INC;
  }

  /**To check and display the fuel.
   The fuel does not exhaust if the the rocket lands or crashes.
   */
  void fuelControl()
  {
    //Checks if the rocket crashes or lands safely
    if (y>=485 || y<=30 || x<=10 || x>width-10)
      fuelDisp++;
    //Calculates fuel based on the status of the rocket
    if (fuelDisp<1)
      fuelConsumed=thrust/.1;
    else
      fuelConsumed=0;

    fuel=(int)(fuel-fuelConsumed);

    //changes the color of fuel display to red if fuel left is 25%
    if (fuel>250)
      fill(0, 255, 0);
    else 
    fill(255, 0, 0);
    textSize(15);
    text("Fuel:"+fuel+" ("+(fuel/10)+"%)", 5, 20);
  }

  /**
   Adjust the position and velocity, and draw the rocket, and display the 
   horizontal and vertical velocities.
   */
  void update() {
    x = x + xVel;
    y = y + yVel;
    xVel = (xVel - cos(tilt)*thrust);
    yVel = (yVel - sin(tilt)*thrust + GRAVITY);
    // to make it more stable set very small values to 0
    if (abs(xVel) < 0.00005) xVel = 0;
    if (abs(yVel) < 0.00005) yVel = 0;
    verVel=(int)(abs(yVel) *100);
    horVel=(int)(abs(xVel) *100);
    fill(255);
    textSize(16);
    text("Horizontal Velocity : " +horVel, 5, 40);
    text("Vertical Velocity : " +verVel, 5, 60);

    // draw it
    pushMatrix();
    translate(x, y);
    rotate(tilt - HALF_PI); 
    // draw the rocket bod
    strokeWeight(1);
    stroke(0);
    fill(200);
    rect(-10, -50, 20, 50);
    fill(0, 150, 255);
    triangle(0, -70, 10, -50, -10, -50); // bad magic numbers here for the rocket body
    pushMatrix();
    rotate(PI/2);
    textSize(10);
    fill(0);
    text("APOLLO", -50, 8);
    popMatrix();
    stroke(255, 0, 0);
    line(3, -50, 3, 0);
    line(5, -50, 5, 0);

    // draw the rocket thrust "flames"
    strokeWeight(5);
    stroke(0, 255, 223);
    line(0, 0, 0, thrust * FLAME_SCALE);
    
    if(checkCrash>0)
    image(img, -30,-60,60,90);

    popMatrix();
  }

  //Method to draw the stars
  void stars() {
    stroke(0);
    strokeWeight(1);
    for (int i = 0; i < starX.length; i++) {
      fill(random(50, 255)); // makes them twinkle
      if (random(10) < 1) {
        starClr[i] = (int)random(100, 255);
      }
      fill(starClr[i]);
      ellipse(starX[i], starY[i], starSz, starSz);
    }
  }

  //Method to draw the American flag
  void flag() {
    strokeWeight(2);
    stroke(255);
    line(rx-5, 470, 400, 500);
    fill(255);
    noStroke();
    rect(rx-5, 470, rw+5, 10);
    fill(0, 0, 255);
    rect(rx-5, 470, rw-10, 5);
    fill(255, 0, 0);
    rect(rx, 470, rw, rl);
    rect(rx, 471.42, rw, rl);
    rect(rx, 472.84, rw, rl);
    rect(rx, 473.26, rw, rl);
    rect(rx-5, 475.68, rw+5, rl);
    rect(rx-5, 477.1, rw+5, rl);
    rect(rx-5, 479.52, rw+5, rl);
  }

  //To check if the rocket lands safely
  void checkLanding()
  {
    //Condition for fuel exhaustion
    if (fuel==0) {
      if (y<480)
        powerCheck-=1;
      if (powerCheck>=0 && y<495)
      {
        textSize(25);
        text("Fuel Exhausted!", width/2 -200, height/2);
        text((powerCheck/60)+" Seconds to Power failure", width/2 -200, height/2 + 20);
      }
      if (powerCheck<1) {
        textSize(25);
        text("Passengers died due to lack of \npower for life support systems!", width/2-250, height/2);
        checkCrash++;
      }
    }
    //Condition for Landing otherwise
    if (y>=485 && y<=486) {
      if (horVel<=60 && verVel<=60)
        landCheck=1;
    }
    if (y>=495) {

      if (powerCheck>1)
      {
        if (landCheck==1)
        {
          fill(0, 255, 0);
          textSize(50);
          text("Safe Landing", width/2 - 150, height/2);
          flag();
        } 
        if (landCheck==0) {
          fill(255, 0, 0);
          textSize(50);
          text("You Died", width/2 - 150, height/2);
          checkCrash++;
        }
      }
      xVel=0;
      yVel=0;
    }
    //Condition to check rocket crashes on side screen
    if (x<=10 || x>= width-10  || y<=30)
    {
      xVel=0;
      yVel=0;
      textSize(50);
      fill(255, 0, 0);
      text("Rocket crashed!", width/2 - 150, height/2);
      checkCrash++;
    }
  }

  private float x, y, xVel, yVel, thrust = GRAVITY, tilt = HALF_PI;
  // the values below were arrived at by trial and error
  // for something that had the responsiveness desired
  static final float GRAVITY = 0.001;
  static final float MAX_THRUST = 5*GRAVITY;
  static final float TILT_INC = 0.005;
  static final int FLAME_SCALE = 5000; // multiplier to determine how long the flame should be based on thrust
}