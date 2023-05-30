import controlP5.*;

//parameters for simulation
ControlP5 cp5;
int numAnts = 100;
int numFoodSources = 10;
int clusterThreshold= 50;
float antSpeed = 1.0;
int antSize = 10;
int foodSize = 10;
int foodAmount = 50;

Ant[] ants;
Food[] foodSources;

void setup() {
  //width = 800, height = 600 
  size(800, 800);
  //generate ants and place them randomly on screen
  cp5 = new ControlP5(this);
  cp5.addSlider("Ant Size")
    .setLabelVisible(true) // set label visibility to true
    .setColorLabel(color(0))
    .setLabel("Ant Size")
    .setPosition(500, 700)
    .setSize(200, 20)
    .setRange(5, 10)
    .setValue(antSize);
   
    cp5.addSlider("Number of Food Sources")
    .setLabel("Number of Food Sources")
    .setColorLabel(color(0))
    .setPosition(20, 700)
    .setSize(200, 20)
    .setRange(1, 20)
    .setValue(numFoodSources);
    
    cp5.addSlider("Size of Food")
    .setLabel("Food Size")
    .setColorLabel(color(0))
    .setPosition(20, 730)
    .setSize(200, 20)
    .setRange(10, 50)
    .setValue(foodSize);
  
    cp5.addSlider("Food Amount")
    .setLabel("Amount of Food")
    .setColorLabel(color(0))
    .setPosition(20, 760)
    .setSize(200, 20)
    .setRange(50, 100)
    .setValue(foodAmount);
    
    cp5.addSlider("Ant Speed")
    .setLabel("Ant Speed")
    .setColorLabel(color(0))
    .setPosition(500, 760)
    .setSize(200, 20)
    .setRange(1, 5)
    .setValue(antSpeed);

    cp5.addSlider("Cluster Threshold")
    .setLabel("Cluster Threshold")
    .setColorLabel(color(0))
    .setPosition(500, 730)
    .setSize(200, 20)
    .setRange(10, 100)
    .setValue(clusterThreshold);
    
  ants = new Ant[numAnts];
  for (int i = 0; i < numAnts; i++) {
    ants[i] = new Ant(random(width), random(height-200));
  }
  //generate food sources at random positions
  foodSources = new Food[numFoodSources];
  
  for (int i = 0; i < numFoodSources; i++) {
    foodSources[i] = new Food(random(width), random(height-200), foodSize, foodAmount);
  }
}
void mousePressed() {
  Ant newAnt = new Ant(mouseX, mouseY);
  
  Ant[] newAnts = new Ant[numAnts + 1];
  arrayCopy(ants, 0, newAnts, 0, numAnts);
  newAnts[numAnts] = newAnt;
  
  ants = newAnts;
  numAnts++;
}

void draw() {
  background(220);
  stroke(0);
  line(0, 660, 800, 660); 
  clusterThreshold = (int) cp5.getController("Cluster Threshold").getValue();
  antSpeed = (int) cp5.getController("Ant Speed").getValue();
  antSize = (int) cp5.getController("Ant Size").getValue();
  numFoodSources = (int) cp5.getController("Number of Food Sources").getValue();
  
  ArrayList<Food> remainingFoodSources = new ArrayList<Food>();
  for (int i = 0; i < numFoodSources && i < foodSources.length; i++) {
    if (foodSources[i].amount > 0) {
      remainingFoodSources.add(foodSources[i]);
    }
  }
  foodSources = remainingFoodSources.toArray(new Food[remainingFoodSources.size()]);

  // Update size of foodSources array
  if (numFoodSources > foodSources.length) {
    Food[] newFoodSources = new Food[numFoodSources];
    arrayCopy(foodSources, 0, newFoodSources, 0, foodSources.length);
    for (int i = foodSources.length; i < numFoodSources; i++) {
      newFoodSources[i] = new Food(random(width), random(height-200), foodSize, foodAmount);
    }
    foodSources = newFoodSources;
  } else if (numFoodSources < foodSources.length) {
    Food[] newFoodSources = new Food[numFoodSources];
    arrayCopy(foodSources, 0, newFoodSources, 0, numFoodSources);
    foodSources = newFoodSources;
  }


  // Move ants and find clusters
  for (int i = 0; i < numAnts; i++) {
    ants[i].move();
    ants[i].findCluster(ants, clusterThreshold);
    ants[i].findFood(foodSources);
    ants[i].display();
  }
  
  // Display food sources
  for (int i = 0; i < numFoodSources; i++) {
    foodSources[i].display();
  }
}

class Ant {
  float x, y; //ants coordinates on screen
  float speed; // speed of ant 
  float eating; // amount of food the ant eats
  
  Ant(float x, float y) {
    this.x = x;
    this.y = y;
    this.speed = antSpeed;
  }
  
  // Move ant randomly
  void move() {
    x += random(-speed, speed);
    y += random(-speed, speed);
    
    // ensure ant remains within the screen
    x = constrain(x, 0, width);
    y = constrain(y, 0, height-200);
  }
  
  // cluster with ants that are near
  void findCluster(Ant[] ants, float threshold) {
    for (Ant ant2 : ants) {
      // skip ant if its the current ant 
      if (ant2 == this) {
        continue;
      }
      // else calculate distance between the two ants
      float d = dist(x, y, ant2.x, ant2.y);
      
      // if distance is less than threshold value, 
      if (d < threshold) {
        // move towards the second ant 
        float _x = ant2.x - x;   //distance in x 
        float _y = ant2.y - y;    //distance in y coords
        
        float angle = atan2(_y, _x); 
        x += cos(angle) * speed;
        y += sin(angle) * speed;
      }
    }
  }
  
  // find foodsource that are near and eat them
  void findFood(Food[] foodSources) { 
    for (int i = 0; i < foodSources.length; i++) {
      //calculate distance between ant and foodsource 
      float d = dist(x, y, foodSources[i].x, foodSources[i].y);
      
      // if distance less than half the size of foodSource 
      if (d < foodSources[i].size/2) {
        foodSources[i].eatFood();
      }
    }
  }
  
  void display() {
  fill(255, 0, 0);
  beginShape();
  vertex(x - antSize / 2, y - antSize / 2);
  vertex(x + antSize / 2, y - antSize / 2);
  vertex(x + antSize / 4, y);
  vertex(x + antSize / 2, y + antSize / 2);
  vertex(x - antSize / 2, y + antSize / 2);
  vertex(x - antSize / 4, y);
  endShape(CLOSE);
}
}

class Food {
  float x, y; // coords of food
  int size; // size of food source
  int amount; // amount of food remaining in the foodSource 
  
  Food(float x, float y, int size, int amount) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.amount = amount;
  }
  
  // display food
  void display() {
    noStroke();
    fill(0, 0, 255);
    ellipse(x, y, size - amount/2, size - amount/2);
  }
  
  // eat food 
  int eatFood() {
    int amount_ = min(amount, 10);
    amount -= amount_;
    return amount_;
  }
}
