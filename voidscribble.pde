//voidscribble 84B05
//by eelfroth

import processing.svg.*;

final int canvas_size = 2048; 
final float weight = 5;
final float scatter = 100;

PGraphics canvas;
float radius;
float[] verts;
int count;
String file;

final String help = "press R to randomize\npress S to export png\npress E to export svg\n";

void setup() {
    size(768, 768, P2D);
    frameRate(10);
    canvas = createGraphics(canvas_size, canvas_size, P2D);
    radius = canvas_size/3;
    println(help);
    randomize();
}

void draw() {
    image(canvas, 0, 0, width, height);

    fill(255);
    textAlign(LEFT, TOP);
    text("happy void day!", 20, 20);
    textAlign(LEFT, BOTTOM);
    text(help, 20, height-20);
    textAlign(RIGHT, TOP);
    text(file, width-20, 20);
    textAlign(RIGHT, BOTTOM);
    text(count*8, width-20, height-20);
}

void randomize() {
    file = "hvd"+year()+month()+day()+hour()+minute()+second();
    count = ceil(random(160));
    print(count*8+" vertices - generating... ");
    verts = new float[count*8]; // 8 coordinates per curve 
    for(int i=0; i<verts.length; i+=2) {
        while(verts[i] == 0 || dist(verts[i], verts[i+1], 0, 0) > radius) {
            float r = random(TWO_PI);
            verts[i] = sin(r) * random(scatter) *radius;
            verts[i+1] = cos(r) * random(scatter)*radius;
        }
    }
    redraw();
}

void redraw() {
    print("drawing... ");
    canvas.beginDraw();
    canvas.background(0);
    canvas.stroke(255);
    canvas.noFill();
    canvas.strokeWeight(weight);
    canvas.translate(radius*1.5, radius*1.5);

    for(int i=0; i<verts.length; i+=2) {
        canvas.beginShape();
        canvas.curveVertex(verts[i], verts[(i+1)%verts.length]);
        canvas.curveVertex(verts[(i+2)%verts.length], verts[(i+3)%verts.length]);
        canvas.curveVertex(verts[(i+4)%verts.length], verts[(i+5)%verts.length]);
        canvas.curveVertex(verts[(i+6)%verts.length], verts[(i+7)%verts.length]);
        canvas.endShape();
    }

    canvas.endDraw();
    print("done!\n");
}

void export_image() {
    print("saving "+file+".png... ");
    canvas.save(file+".png");
    print("done!\n");
}

void export_svg() {
    print("exporting "+file+".svg... ");
    beginRecord(SVG, file+".svg");

    float s = float(height)/canvas.height;
    float o = radius*1.5*s;

    background(0);
    stroke(255);
    noFill();
    strokeWeight(weight*s);

    for(int i=0; i<verts.length; i+=2) {
        beginShape();
        curveVertex(verts[i]*s+o, verts[(i+1)%verts.length]*s+o);
        curveVertex(verts[(i+2)%verts.length]*s+o, verts[(i+3)%verts.length]*s+o);
        curveVertex(verts[(i+4)%verts.length]*s+o, verts[(i+5)%verts.length]*s+o);
        curveVertex(verts[(i+6)%verts.length]*s+o, verts[(i+7)%verts.length]*s+o);
        endShape();
    }

    endRecord();
    print("done!\n");
}

void keyPressed() {
    switch(key) {
        case 'r':
        case 'R':
            randomize();
            break;
        case 's':
        case 'S':
            export_image();
            break;
        case 'e':
        case 'E':
            export_svg();
            break;
        case 'q':
        case 'Q':
            exit();
    }
}
