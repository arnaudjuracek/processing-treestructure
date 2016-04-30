import toxi.geom.*;

// optional
import peasy.*;
import toxi.processing.*;
PeasyCam cam;
ToxiclibsSupport gfx;


Tree tree;
ArrayList<Traveler> travelers;

void setup(){
	size(800, 800, OPENGL);
	if(frameCount==0) cam = new PeasyCam(this, 2000);
	gfx = new ToxiclibsSupport(this);

	tree = new Tree(new Vec3D(0,0,0), new Vec3D(100,0,0));
	tree.insertBranch(tree.getLastNode(), new Node(Vec3D.randomVector().scale(100).interpolateToSelf(tree.getRandomBranch().getRandomNode().getVector(), -1)));
	Node n = tree.getLastNode();
	for(int i=0; i<10; i++){
		// if(random(1)>.7) tree.insertBranch(tree.getRandomNode(), new Node(Vec3D.randomVector().scale(100).interpolateToSelf(tree.getRandomBranch().getRandomNode().getVector(), -1)));
		// else tree.insertBranch(tree.getLastNode(), new Node(Vec3D.randomVector().scale(100).interpolateToSelf(tree.getRandomBranch().getRandomNode().getVector(), -1)));
	 	tree.insertBranch(n, new Node(Vec3D.randomVector().scale(100).interpolateToSelf(tree.getRandomBranch().getRandomNode().getVector(), -1)));
	}
		// for(int a=0; a<360; a+=30){
		// 	for(int b=0; b<180; b+=30){
		// 		float
		// 			x = 100 * sin(a)*cos(b),
		// 			y = 100 * sin(a)*sin(b),
		// 			z = 100 * cos(a);
		// 		Vec3D v = new Vec3D(x,y,z);
		// 		tree.insertBranch(tree.getRoot(), new Node(v));
		// 	}
		// }
	travelers = new ArrayList<Traveler>();
	for(int i=0; i<10; i++) travelers.add( new Traveler(tree) );

	// spawntree();
}

void draw(){
	background(50);

	stroke(255);
	strokeWeight(5);
	tree.drawNodes();

	// for(Branch b : tree.getBranches()){
	// 	float d = norm(b.getDepth(), 0, tree.getDepth());
	// 	strokeWeight(map(d,0,1, 10, 1));
	// 	stroke(255, map(d,0,1, 100, 255), map(d,0,1, 255, 100));
	// 	b.draw();
	// }

	strokeWeight(1);
	stroke(255);
	tree.drawBranches();

	for(Node n : tree.getLeaves()){
		strokeWeight(6);
		stroke(255, 200, 0);
		n.draw();
	}

	noFill();
	strokeWeight(1);
	stroke(255, 10);
	gfx.mesh(tree.getAABB().toMesh());

	strokeWeight(5);
	stroke(255, 0, 255);
	Vec3D c = tree.getCentroid();
	point(c.x, c.y, c.z);

	// Node centroid = tree.getNearestNode(c);
	stroke(0, 255, 255);
	tree.getRoot().draw();
	// centroid.draw();

	// for(Branch b : centroid.getParents()){
	// 	strokeWeight(2);
	// 	b.draw();
	// }

	// TRAVELER
	for(Traveler t : travelers){
		strokeWeight(20);
		stroke(0, 0, 255);
		t.getCurrentNode().draw();

		strokeWeight(2);
		stroke(0, 0, 255);
		for(Branch b : t.getPath()) b.draw();
	}


	// DISPLAY INFOS
	cam.beginHUD();
		textAlign(LEFT, BOTTOM);
		fill(255, 200);
		text(
			tree.getDepth() + " depth level" + "\n" +
			tree.getNodes().size() + " nodes" + "\n" +
			tree.getBranches().size() + " branches",
			10, height - 10);
	cam.endHUD();
}


void keyPressed(){
	if(keyCode == LEFT) for(Traveler t : travelers) t.previous();
	if(keyCode == RIGHT) for(Traveler t : travelers) t.next();


	if(key == 'r') setup();
	// if(key == 'r') spawntree();
	if(key == ' '){
		for(Traveler t : travelers) t.createPath(tree.getRoot());
		Node n = new Node( Vec3D.randomVector().scale(100) );
		Node from = tree.getLeaves().get(int(random(tree.getLeaves().size())));
		Branch b = tree.insertBranch(from, n);
	}
	if(key == 'i'){
		Branch b = tree.getRandomBranch();
		Node n = tree.insertNodeToBranch(b, random(.25, .75));
	}
	if(key == 'b'){
		Node from = tree.getRandomNode();
		// Node n = new Node( Vec3D.randomVector().scale(100) );
		Vec3D n = from.getVector().interpolateTo(tree.getNearestNeighborNode(from).getVector(), random(-1, -.5)).jitter(10);
		tree.insertBranch(from, new Node(n));
	}
}

// void spawntree(){
// 	int levels = 5;
// 	tree = new Tree(new Vec3D(0,0,0), new Vec3D(0, -100, 0));

// 	for(int level=2; level<levels+2; level++){
// 		for(Node n : tree.getLeaves()){
// 			Vec3D start = tree.getNearestNeighborNode(n).getVector();
// 			for(int i=0; i<3; i++){
// 				Vec3D direction = n.getVector().interpolateTo(start, -1/level).jitter(10);
// 				tree.insertBranch(n, new Node(direction));
// 			}
// 		}
// 	}
// }