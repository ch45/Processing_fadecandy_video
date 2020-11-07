import processing.video.*;
Movie movie;

OPC opc;
final String fcServerHost = "127.0.0.1";
final int fcServerPort = 7890;

String filename = "flag_400_300.mp4";
// String filename = "launch1.mp4";
// String filename = "skate01.mp4";
int exitTimer = 0;

// We can use this to mess with the aspect ratio of the video as the grid is currently 1:1
int verticalBorder = 100;  // Bars at the sides of the display
int horizontalBorder = 0;  // Bars at the top and bottom of display

final int boxesAcross = 2;
final int boxesDown = 2;
final int ledsAcross = 8;
final int ledsDown = 8;
// initialized in setup()
float spacing;
int x0;
int y0;

void setup()
{
  apply_cmdline_args();

  size(720, 405);

  movie = new Movie(this, filename);
  movie.loop();

  opc = new OPC(this, fcServerHost, fcServerPort); // Connect to an instance of fcserver

  spacing = (float)min(height / (boxesDown * ledsDown + 1), width / (boxesAcross * ledsAcross + 1));
  x0 = (int)(width - spacing * (boxesAcross * ledsAcross - 1)) / 2;
  y0 = (int)(height - spacing * (boxesDown * ledsDown - 1)) / 2;

  final int boxCentre = (int)((ledsAcross - 1) / 2.0 * spacing); // probably using the centre in the ledGrid8x8 method
  int ledCount = 0;
  for (int y = 0; y < boxesDown; y++) {
    for (int x = 0; x < boxesAcross; x++) {
      opc.ledGrid8x8(ledCount, x0 + spacing * x * ledsAcross + boxCentre, y0 + spacing * y * ledsDown + boxCentre, spacing, 0, false, false);
      ledCount += ledsAcross * ledsDown;
    }
  }
}

void draw()
{
  image(movie, verticalBorder, horizontalBorder, width-(2*verticalBorder), height-(2*horizontalBorder));

  if (exitTimer > 0 && millis() / 1000 > exitTimer) {
    exit();
  }
}

void movieEvent(Movie m)
{
  m.read();
}

void apply_cmdline_args()
{
  if (args == null) {
    return;
  }
  for (String exp: args) {
      String[] comp = exp.split("=");
      switch (comp[0]) {
        case "file":
          filename = comp[1];
          println("use filename " + filename);
          break;
        case "exit":
          exitTimer = parseInt(comp[1], 10);
          println("exit after " + exitTimer + "s");
          break;
      }
  }
}
