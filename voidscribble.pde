final int radius = 2048;
int count = 65;
float weight = 10;

PGraphics canvas;
float[] verts;

final String help = "happy void day!\n\npress R to randomize\npress S to export image\nadjust number of curves with + and -\n";

void setup() {
    size(768, 768, P2D);
    frameRate(15);
    canvas = createGraphics(radius*3, radius*3, P2D);
    
    println(help);
    randomize();
}

void draw() {
    image(canvas, 0, 0, width, height);
    fill(255);
    text(help+"count: "+count, 20, 20);
    if(keyPressed) {
        switch(key) {
            case 'r':
            case 'R':
                randomize();
                break;
            case 's':
            case 'S':
                export();
                break;
            case '+':
                count += 1;
                randomize();
                break;
            case '-':
                count = max(count-1, 1);
                randomize();
                break;
            case ']':
                weight *= 1.2;
                redraw();
                break;
            case '[':
                weight = max(weight/1.2, 1);
                redraw();
                break;
        }
    }
}

void randomize() {
    print("randomizing "+count+" curves... ");
    verts = new float[count*8]; // 8 coordinates per curve 
    for(int i=0; i<verts.length; i+=2) {
        while(verts[i] == 0 || dist(verts[i], verts[i+1], 0, 0) > radius) {
            float r = random(TWO_PI);
            verts[i] = sin(r) * random(100) *radius;
            verts[i+1] = cos(r) * random(100)*radius;
        }
    }
    print("done!\n");
    redraw();
}

void redraw() {
    canvas.beginDraw();
    canvas.background(0);
    canvas.stroke(255);
    canvas.noFill();
    canvas.strokeWeight(weight);
    canvas.translate(radius*1.5, radius*1.5);
    canvas.rotate(PI/4);

    for(int i=0; i<verts.length; i+=2) {
        canvas.beginShape();
        canvas.curveVertex(verts[i], verts[(i+1)%verts.length]);
        canvas.curveVertex(verts[(i+2)%verts.length], verts[(i+3)%verts.length]);
        canvas.curveVertex(verts[(i+4)%verts.length], verts[(i+5)%verts.length]);
        canvas.curveVertex(verts[(i+6)%verts.length], verts[(i+7)%verts.length]);
        canvas.endShape();
    }

    canvas.endDraw();
}

void export() {
    String file = "hvd"+year()+month()+day()+hour()+minute()+second()+".png";
    print("saving "+file+"... ");
    canvas.save(file);
    print("done!\n");
}
