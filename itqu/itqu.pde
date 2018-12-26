/* 
   voidscribble 84B05
*/

import processing.svg.*;

final int canvas_size = 2048; 

int count = 64;
int mod = 0;
int weight = 5;

PGraphics canvas;
float radius;
float[] verts;
float scatter = 100;
String file = "";
PFont font;

String exporting;
String generating = "random";

final String help = "r R  random\nm M  mesh\n\ns    save png\ne    export svg\n\n+ -  vertex count\n. ,  stroke weight";

void setup() {
    size(768, 768, P2D);

    font = createFont("DejaVuSansMono.ttf", 12, true);
    textFont(font);

    background(0);
    //println(help);
}

void draw() {
    if(frameCount <= 1) {
        fill(255);
        textAlign(CENTER, BOTTOM);
        text("loading...", width/2, height-20);
        if(frameCount == 1) {
            canvas = createGraphics(canvas_size, canvas_size, P2D);
            radius = canvas_size/3;
        }
        return;
    }

    if(keyPressed) { // continuous keypresses
        switch(key) {
            case '+':
                count++;
                break;
            case '-':
                count = max(1, count-1);
                break;
        }
    }

    tint(255, 20);
    image(canvas, 0, 0, width, height);
    noTint();

    fill(0);
    stroke(0);
    rect(18, 20, 98, 14);
    rect(18, height-168, 130, 148);
    rect(width-120, 20, 102, 14);
    rect(width-80, height-72, 62, 52);
    fill(255);
    textAlign(LEFT, TOP);
    text("H     V     D", 20, 20);
    textAlign(LEFT, BOTTOM);
    text(help, 20, height-20);
    textAlign(RIGHT, TOP);
    text(file, width-20, 20);
    textAlign(RIGHT, BOTTOM);
    text(mod + "\n" + count*8 + "\n" + weight, width-20, height-20);

    if (generating != null) {
        switch(generating) {
            case "random":
            case "mesh":
                textAlign(CENTER, BOTTOM);
                text("generating "+generating+"...", width/2, height-20);
                generating += "!";
                break;
            case "random!":
                randomize();
                generating = null;
                break;
            case "mesh!":
                mesh();
                generating = null;
                break;
        }
    } else if (exporting != null) {
        switch(exporting) {
            case "png":
            case "svg":
                textAlign(CENTER, BOTTOM);
                text("exporting "+exporting+"...", width/2, height-20);
                exporting += "!";
                break;
            case "png!":
                export_png();
                exporting = null;
                break;
            case "svg!":
                export_svg();
                exporting = null;
                break;
        }
    }
}

void clear() {
    file = ""+year()+month()+day()+hour()+minute()+second();
    //count = ceil(random(512));
    print(count*8+" vertices - generating... ");
    verts = new float[count*8];
}

void randomize() {
    clear();
    for(int i=0; i<verts.length; i+=2) {
        while(verts[i] == 0 || dist(verts[i], verts[i+1], 0, 0) > radius) {
            float a = random(TWO_PI);
            verts[i] = sin(a) * random(scatter) *radius;
            verts[i+1] = cos(a) * random(scatter)*radius;
        }
    }
    redraw();
}

void mesh() {
    clear();
    mod += 1;
    for(int i=0; i<verts.length; i+=2) {
        //float r = TWO_PI/verts.length * i * ((i/((mod%8)+1))%(4*ceil(float(mod)/8)));
        float a = TWO_PI/verts.length * i * (i % (mod+2));
        verts[i] = sin(a) *  radius;
        verts[i+1] = cos(a) *  radius;
    }
    redraw();
}


void redraw() {
    print("drawing... ");
    canvas.beginDraw();
    canvas.background(0);
    canvas.stroke(255);
    canvas.noFill();
    canvas.strokeWeight(weight+0.1);
    canvas.translate(radius*1.5, radius*1.5);

    for(int i=0; i<verts.length; i+=2) {
        canvas.beginShape();
        for(int k=0; k<8; k+=2) {
            canvas.curveVertex(verts[(i+k)%verts.length], verts[(i+k+1)%verts.length]);
        }
        canvas.endShape();
    }

    canvas.endDraw();
    print("done!\n");
}

void export_png() {
    print("saving hvd"+file+".png... ");
    canvas.save("hvd"+file+".png");
    print("done!\n");
}

void export_svg() {
    print("exporting hvd"+file+".svg... ");
    beginRecord(SVG, "hvd"+file+".svg");

    float s = float(height)/canvas.height;
    float o = radius*1.5*s;

    background(0);
    stroke(255);
    noFill();
    strokeWeight((weight+0.1)*s);

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

void keyPressed() { // single keypresses
    switch(key) {
        case 'r':
            scatter = 100;
            generating = "random";
            break;
        case 'R':
            scatter = 1;
            generating = "random";
            break;
        case 'M':
            mod = max(-1, mod-2);
        case 'm':
            generating = "mesh";
            break;
        case 's':
        case 'S':
            exporting = "png";
            break;
        case 'e':
        case 'E':
            exporting = "svg";
            break;
        case 'q':
        case 'Q':
            exit();
            break;
        case '.':
            weight = min(32, weight+1);
            break;
        case ',':
            weight = max(0, weight-1);
            break;
    }
}
