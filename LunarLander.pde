/*A progam to create a game similar to Lunar Lander.
 You control the rocket with the arrow keys or 'a' and 'd' plus the mouse for thrust.
 The rocket crashes when it hits the sides of the the window,
 and the maximum horizontal and vertical velocities for landing are 50 each.
 If the fuel exhausts, the power in the rocket goes out in 8 seconds.
 On a succesfull landing, the american flag shows up.
 Authors : Rahul Mahendru & Chris Cai*/

//Setup method
void setup() {
  size(800, 600);
  rocket = new Rocket(width/6, height/2);
}

//Initialization of objects
Rocket rocket;

//Draw method
void draw() {
  background(0);
  adjustControls(rocket);
  rocket.stars();
  rocket.update();
  rocket.fuelControl();
  rocket.checkLanding();
  platform(-10, 500, 950, 100);
}

//Method to draw the platform for the landing of the rocket
void platform(int px, int py, int pWidth, int pHeight) {
  strokeWeight(10);
  stroke(90, 255, 234);
  fill(255);
  rect(px, py, pWidth, pHeight);
}

/*
  Control the rocket using mouseY for thrust and 'a' or left-arrow for rotating
 counter-clockwise and 'd' or right-arrow for rotating clockwise.
 It takes a single parameter, which is the rocket being controlled.
 */
void adjustControls(Rocket rocket) {
  // control thrust with the y-position of the mouse
  if (mouseY < height/2) {
    rocket.setThrust(height/2 - mouseY);
  } else {
    rocket.setThrust(0);
  }

  // allow for right handed control with arrow keys or
  // left handed control with 'a' and 'd' keys

  // right hand rotate controls
  if (keyPressed) {
    if (key == CODED) { // tells us it was a "special" key
      if (keyCode == RIGHT) {
        rocket.rotateRocket(1);
      } else if (keyCode == LEFT) {
        rocket.rotateRocket(-1);
      }
    }
    // left hand rotate controls
    else if (key == 'a') {
      rocket.rotateRocket(-1);
    } else if (key == 'd') {
      rocket.rotateRocket(1);
    }
  }
}