// //<>// //<>// //<>// //<>// //<>//
//  UI.pde
//  Lightwork-Mapper
//
//  Created by Leo Stefansson and Tim Rolls
//  
//  This class builds the UI for the application
//
//////////////////////////////////////////////////////////////

import controlP5.*;

Textarea cp5Console;
Println console;
RadioButton r1, r2;
boolean isUIReady = false;
boolean showLEDColors = true;

int loadWidth =0;

void buildUI() {
  println("setting up ControlP5");

  cp5 = new ControlP5(this);
  //topPanel = new ControlP5(this);

  float startTime = millis(); 
  println("Building UI... at time: " + startTime);
  int uiGrid = 80*guiMultiply;
  int uiSpacing = 20 *guiMultiply;
  int buttonHeight = 30 *guiMultiply;
  int buttonWidth =200 *guiMultiply;

  println("Creating font...");
  PFont pfont = createFont("OpenSans-Regular.ttf", 12*guiMultiply, false); // use true/false for smooth/no-smooth
  ControlFont font = new ControlFont(pfont, 12*guiMultiply);
  cp5.setFont(font);
  cp5.setColorBackground(#333333);
  cp5.setPosition(uiSpacing, uiSpacing);

  Group top = cp5.addGroup("top")
    .setPosition(0, 0)
    .setBackgroundHeight(30*guiMultiply)
    .setWidth(width-uiSpacing*2)
    //.setBackgroundColor(color(255, 50))
    //.disableCollapse()
    .hideBar()
    ;

  Group net = cp5.addGroup("network")
    .setPosition(0, (70*guiMultiply)+camDisplayHeight)
    .setBackgroundHeight(200*guiMultiply)
    .setWidth(uiGrid*4)
    //.setBackgroundColor(color(255, 50))
    .hideBar()
    ;

  Group settings = cp5.addGroup("settings")
    .setPosition(cp5.get("network").getWidth()+uiSpacing, (70*guiMultiply)+camDisplayHeight)
    .setBackgroundHeight(200*guiMultiply)
    .setWidth(uiGrid*4)
    //.setBackgroundColor(color(255, 50))
    .hideBar()
    ;

  //loadWidth = width/12*6;
  println("adding textfield for IP");
  cp5.addTextfield("ip")
    .setPosition(0, buttonHeight+uiSpacing)
    .setSize(buttonWidth, buttonHeight)
    .setAutoClear(false)
    .setGroup("network")
    .setValue(network.getIP())
    .getCaptionLabel().align(ControlP5.RIGHT_OUTSIDE, CENTER).setPadding(5*guiMultiply, 5*guiMultiply)
    ;
  println("done adding textfield for IP");

  println("adding textfield for ledsPerStrip");
  cp5.addTextfield("leds_per_strip")
    .setCaptionLabel("leds per strip")
    .setPosition(0, buttonHeight*2+uiSpacing*2)
    .setSize(buttonWidth, buttonHeight)
    .setAutoClear(false)
    .setGroup("network")
    .setValue(str(network.getNumLedsPerStrip()))
    .getCaptionLabel().align(ControlP5.RIGHT_OUTSIDE, CENTER).setPadding(5*guiMultiply, 5*guiMultiply)
    ;

  println("adding textfield for strips");
  cp5.addTextfield("strips")
    .setPosition(0, buttonHeight*3+uiSpacing*3)
    .setSize(buttonWidth, buttonHeight)
    .setAutoClear(false)
    .setGroup("network")
    .setValue(str(network.getNumStrips()))
    .getCaptionLabel().align(ControlP5.RIGHT_OUTSIDE, CENTER).setPadding(5*guiMultiply, 5*guiMultiply)
    ;

  println("listing drivers");
  //draw after text boxes so the dropdown overlaps properly
  List driver = Arrays.asList("PixelPusher", "Fadecandy"); //"ArtNet"  removed for now - throws errors
  println("adding scrollable list for drivers");
  cp5.addScrollableList("driver")
    .setPosition(0, 0)
    .setSize(buttonWidth, 300)
    .setBarHeight(buttonHeight)
    .setItemHeight(buttonHeight)
    .addItems(driver)
    .setType(ControlP5.DROPDOWN)
    .setOpen(false)
    .bringToFront() 
    .setGroup("network");
  ;
  //TODO  fix style on dropdown 
  cp5.getController("driver").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER).setPaddingX(10);

  println("adding connect button");
  cp5.addButton("connect")
    .setPosition(buttonWidth+uiSpacing, 0)
    .setSize(buttonWidth/2-2, buttonHeight)
    .setGroup("network");
  ;

  println("adding contrast slider");
  cp5.addSlider("cvContrast")
    .setCaptionLabel("contrast")
    .setBroadcast(false)
    .setPosition(0, 0)
    .setSize(buttonWidth, buttonHeight)
    .setRange(0, 5)
    .setValue(cvContrast)
    .setGroup("settings")
    .setBroadcast(true)
    .getCaptionLabel().align(ControlP5.RIGHT_OUTSIDE, CENTER).setPadding(5*guiMultiply, 5*guiMultiply)
    ;

  ////set labels to bottom
  //cp5.getController("cvContrast").getValueLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  //cp5.getController("cvContrast").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

  println("adding slider for cvThreshold");
  cp5.addSlider("cvThreshold")
    .setCaptionLabel("threshold")
    .setBroadcast(false)
    .setPosition(0, buttonHeight+uiSpacing)
    .setSize(buttonWidth, buttonHeight)
    .setRange(0, 255)
    .setValue(cvThreshold)
    .setGroup("settings")
    .setBroadcast(true)
    .getCaptionLabel().align(ControlP5.RIGHT_OUTSIDE, CENTER).setPadding(5*guiMultiply, 5*guiMultiply)

    ;

  ////set labels to bottom
  //cp5.getController("cvThreshold").getValueLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  //cp5.getController("cvThreshold").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

  println("adding slider for ledBrightness");
  cp5.addSlider("ledBrightness")
    .setCaptionLabel("led brightness")
    .setBroadcast(false)
    .setPosition(0, (buttonHeight+uiSpacing)*2)
    .setSize(buttonWidth, buttonHeight)
    .setRange(0, 255)
    .setValue(ledBrightness)
    .setGroup("settings")
    .setBroadcast(true)
    .getCaptionLabel().align(ControlP5.RIGHT_OUTSIDE, CENTER).setPadding(5*guiMultiply, 5*guiMultiply)
    ;

  ////set labels to bottom
  //cp5.getController("ledBrightness").getValueLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
  //cp5.getController("ledBrightness").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);

  println("adding test button");
  cp5.addButton("test")
    .setPosition(0, (buttonHeight+uiSpacing)*3)
    .setSize(buttonWidth/2-2, buttonHeight)
    .setGroup("settings")
    ;

  println("adding map button"); 
  cp5.addButton("map")
    .setPosition(buttonWidth/2, (buttonHeight+uiSpacing)*3)
    .setSize(buttonWidth/2-2, buttonHeight)
    .setGroup("settings")

    ;

  println("adding save button");
  cp5.addButton("save")
    .setPosition(buttonWidth+uiSpacing, (buttonHeight+uiSpacing)*3)
    .setSize(buttonWidth/2, buttonHeight)
    .setGroup("settings")
    ;

  //loadWidth = width/12*9;
  //capture console events to ui
  cp5.enableShortcuts();
  cp5Console = cp5.addTextarea("cp5Console")
    .setPosition((cp5.get("settings").getWidth())*2 +uiSpacing*2, (70*guiMultiply)+camDisplayHeight)
    .setSize((uiGrid*4)-uiSpacing, 180*guiMultiply)
    .setFont(createFont("", 12*guiMultiply))
    .setLineHeight(16*guiMultiply)
    .setColor(color(200))
    .setColorBackground(color(#333333))
    .setColorForeground(color(255, 100))
    ;
  ;

  //println("adding console");
  //TODO: IS this breaking things?
  //console = cp5.addConsole(cp5Console).;//
  //console.play();

  //println("add framerate panel");
  //cp5.addFrameRate().setPosition(0, height-(buttonHeight+uiSpacing));

  r1 = cp5.addRadioButton("videoIn")//.setTitle("Video Input Mode")
    .setPosition(buttonWidth*2, 0)
    .setSize(buttonWidth/4, buttonHeight)
    .setGroup("top")
    .setColorForeground(color(120))
    .setColorActive(color(255))
    .setColorLabel(color(255))
    .setItemsPerRow(5)
    .setSpacingColumn(uiSpacing*3)
    .addItem("Camera", 1)
    .addItem("File", 2)
    .activate(0)
    ;

  r2 = cp5.addRadioButton("stereoToggle")
    .setPosition(buttonWidth*4, 0)
    .setSize(buttonWidth/4, buttonHeight)
    .setGroup("top")
    .setColorForeground(color(120))
    .setColorActive(color(255))
    .setColorLabel(color(255))
    .setItemsPerRow(5)
    .setSpacingColumn(uiSpacing*3)
    .addItem("2D", 1)
    .addItem("3D", 2)
    .activate(0)
    ;

  //Refresh connected cameras
  println("cp5: adding refresh button");
  cp5.addButton("refresh")
    .setPosition(buttonWidth+uiSpacing, 0)
    .setSize(buttonWidth/2, buttonHeight)
    .setGroup("top")
    ;

  // made last - enumerating cams will break the ui if done earlier in the sequence
  println("cp5: adding camera dropdown list");
  cp5.addScrollableList("camera")
    .setPosition(0, 0)
    .setSize(buttonWidth, 300)
    .setBarHeight(buttonHeight)
    .setItemHeight(buttonHeight)
    .addItems(enumerateCams())
    .setOpen(false)
    .setGroup("top")
    ;

  // Wrap up, report done
  //loadWidth = width;
  float deltaTime = millis()-startTime; 
  println("Done building GUI, total time: " + deltaTime + " ms"); 
  isUIReady = true;
}

//////////////////////////////////////////////////////////////
// Event Handlers
//////////////////////////////////////////////////////////////

void camera(int n) {
  Map m = cp5.get(ScrollableList.class, "camera").getItem(n);
  //println(m);
  String label=m.get("name").toString();
  //println(label);
  switchCamera(label);
}

void driver(int n) { 
  String label = cp5.get(ScrollableList.class, "driver").getItem(n).get("name").toString().toUpperCase();

  if (label.equals("PIXELPUSHER")) {
    network.shutdown();
    network.setMode(device.PIXELPUSHER);
    println("network: PixelPusher");
  }
  if (label.equals("FADECANDY")) {
    network.shutdown();
    network.setMode(device.FADECANDY);
    println("network: Fadecandy");
  }
  if (label.equals("ARTNET")) {
    network.shutdown();
    network.setMode(device.ARTNET);
    println("network: ArtNet");
  }
}

public void ip(String theText) {
  println("IP set to : "+theText);
  network.setIP(theText);
}

public void leds_per_strip(String theText) {
  println("Leds per strip set to : "+theText);
  network.setNumLedsPerStrip(int(theText));
}

public void strips(String theText) {
  println("Strips set to : "+theText);
  network.setNumStrips(int(theText));
}

public void connect() {

  if (network.getMode()!=device.NULL) {
    network.connect(this);
  } else {
    println("Please select a driver type from the dropdown before attempting to connect");
  }

  if (network.getMode()==device.PIXELPUSHER) {
    network.fetchPPConfig();
    cp5.get(Textfield.class, "ip").setValue(network.getIP());
    cp5.get(Textfield.class, "leds_per_strip").setValue(str(network.getNumLedsPerStrip()));
    cp5.get(Textfield.class, "strips").setValue(str(network.getNumStrips()));
  }

  if (network.isConnected()) {
    cp5.get("connect").setColorBackground(color(0, 255, 0));
    cp5.get("connect").setCaptionLabel("Refresh");
  }
}

public void refresh() {
  String[] cameras = enumerateCams();
  cp5.get(ScrollableList.class, "camera").setItems(cameras);
}


public void cvThreshold(int value) {
  cvThreshold = value;
  //opencv.threshold(cvThreshold);
  //println("set Open CV threshold to "+cvThreshold);
}

public void cvContrast(float value) {
  cvContrast =value;
  //opencv.contrast(cvContrast);
  //println("set Open CV contrast to "+cvContrast);
}

public void ledBrightness(int value) {
  ledBrightness =value;
  animator.setLedBrightness(ledBrightness);
}

public void test() {
  if (network.isConnected()==false) {
    println("please connect to a device before testing");
  } else if (animator.getMode()!=animationMode.TEST) {
    animator.setMode(animationMode.TEST);
    println("Test mode");
  } else {
    animator.setMode(animationMode.OFF);
    println("Animator off");
  }
}

public void map() {
  if (network.isConnected()==false) {
    println("please connect to a device before mapping");
  } else if (animator.getMode()!=animationMode.CHASE) {
    isMapping=!isMapping;
    animator.setMode(animationMode.CHASE);
    println("Chase mode");
  } else {
    isMapping=!isMapping;
    animator.setMode(animationMode.OFF);
    println("Animator off");
  }
}

public void save() {
  if (key == 's') {
    saveSVG(coords);
  }
}



//////////////////////////////////////////////////////////////
// Camera Switching
//////////////////////////////////////////////////////////////

//get the list of currently connected cameras
String[] enumerateCams() {

  //} else {
  //  println("Available cameras:");
  //  printArray(cameras);
  //  //cam = new Capture(this, camWidth, camHeight, 30);
  //  //cam = new Capture(this, cameras[0]);
  //  cam = new Capture(this, camWidth, camHeight, cameras[0], FPS);
  //  cam.start();
  //}

  //int startTime = millis();
  //parse out camera names
  String[] list = Capture.list();
  //int endTime =millis();
  //println("listing cams took: "+(startTime-endTime));

  //catch null cases
  //if (cameras == null) {
  //  println("Failed to retrieve the list of available cameras, will try the default...");
  //  cam = new Capture(this, camWidth, camHeight, FPS);
  //} else if (cameras.length == 0) {
  //  println("There are no cameras available for capture.");
  //  exit();

  for (int i=0; i<list.length; i++) {
    String item = list[i]; 
    String[] temp = splitTokens(item, ",=");
    list[i] = temp[1];
  }

  //This operation removes duplicates from the camera names, leaving only individual device names
  //the set format automatically removes duplicates without having to iterate through them
  Set<String> set = new HashSet<String>();
  Collections.addAll(set, list);
  String[] cameras = set.toArray(new String[0]);

  return cameras;
}

//UI camera switching
void switchCamera(String name) {
  cam.stop();
  cam=null;
  cam =new Capture(this, camWidth, camHeight, name, 30);
  cam.start();
}