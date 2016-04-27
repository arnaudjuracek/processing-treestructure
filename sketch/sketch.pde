import peasy.*;
import toxi.geom.*;

Tree tree;
PeasyCam cam;

int nodeIndex = 0;

void setup(){
	size(800, 800, OPENGL);
	cam = new PeasyCam(this, 1000);
	tree = new Tree(new Vec3D(0,0,0), new Vec3D(100,0,0));
	nodeIndex = 0;
}

Node select = null;

void draw(){
	background(50);
	// tree.draw();

	stroke(255);
	strokeWeight(5);
	tree.drawNodes();

	strokeWeight(1);
	tree.drawBranches();


	for(Node n : tree.getEnds()){
		strokeWeight(6);
		stroke(255, 200, 0);
		n.draw();
	}


	// DISPLAY INFOS
	cam.beginHUD();
		textAlign(LEFT, BOTTOM);
		fill(255, 200);
		text(
			nodeIndex + "\n" +
			tree.NODES.size() + " nodes" + "\n" +
			tree.BRANCHES.size() + " branches",
			10, height - 10);
	cam.endHUD();
}


void keyPressed(){
	if(keyCode == LEFT) nodeIndex = abs(--nodeIndex) % tree.NODES.size();
	if(keyCode == RIGHT) nodeIndex = ++nodeIndex % tree.NODES.size();
	if(key == 'n'){
		select = tree.getRandomNode();
	}
	if(key == 'r') setup();
	if(key == ' '){
		Node n = new Node( Vec3D.randomVector().scale(300) );
		// Node n = new Node( tree.heading().scale(random(100)).jitter(10) );
		Branch b = tree.addBranch(tree.getRandomNode(), n);
		for(int i=0; i<random(10); i++) b.insertNode(random(.25, .75));
	}
	if(key == 'i'){
		Branch b = tree.getRandomBranch();
		Node n = tree.insertNodeToBranch(b, random(.25, .75));
	}
	if(key == 'b'){
		Node n = new Node( Vec3D.randomVector().scale(300) );
		tree.addBranch(tree.getRandomNode(), n);
	}
}
