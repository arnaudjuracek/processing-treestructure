public class Tree{
	private ArrayList<Branch> BRANCHES;
	private ArrayList<Node> NODES;

	// -------------------------------------------------------------------------
	// CONSTRUCTOR
	// create a trunk from a Vec3D to another
	Tree(Vec3D from, Vec3D to){
		this.NODES = new ArrayList<Node>(); // must be instantiated before the first branch instantiation

		Node
			trunk_start = new Node(from),
			trunk_end = new Node(to);
		Branch trunk = new Branch(this, trunk_start, trunk_end);

		this.BRANCHES = new ArrayList<Branch>();
		this.BRANCHES.add(trunk);
	}



	// -------------------------------------------------------------------------
	// GETTERS
	public ArrayList<Node> getNodes(){ return this.NODES; }
	public Node getNode(int index){ return this.NODES.get(index); }
	public Node getFirstNode(){ return this.NODES.get(0); }
	public Node getLastNode(){ return this.NODES.get(this.NODES.size()-1); }
	public Node getRandomNode(){ return this.NODES.get(int(random(this.NODES.size()))); }

	public ArrayList<Branch> getBranches(){ return this.BRANCHES; }
	public Branch getBranch(int index){ return this.BRANCHES.get(index); }
	public Branch getFirstBranch(){ return this.BRANCHES.get(0); }
	public Branch getLastBranch(){ return this.BRANCHES.get(this.BRANCHES.size()-1); }
	public Branch getRandomBranch(){ return this.BRANCHES.get(int(random(this.BRANCHES.size()))); }




	// ---------------------------------------------------------------------------
	// SETTERS
	// add a new branch to the Tree from a node to another
	// return the new branch
	public Branch addBranch(Node from, Node to){
		Branch b = new Branch(this, from, to);
		this.BRANCHES.add(b);
		return b;
	}

	// insert a node on a specific branch, with its position determined by a factor from 0 to 1,
	// 0 being the start of the branch, and 1 its end
	// return the inserted node
	public Node insertNodeToBranch(Branch branch, float position){
		return branch.insertNode(position);
	}



	// -------------------------------------------------------------------------
	// MATHS & GEOM HELPERS
	// return the average direction of the tree's branches as a normalized 3D vector
	public Vec3D heading(){
		Vec3D average = new Vec3D();
		for(Branch b : this.getBranches()) average.addSelf(b.heading().scale(b.length()));
		return average.normalize();
	}

	// return the centroid of the as a 3D vector
	// public Vec3D centroid(){}

	// return the bounding box of the tree as a Axis Align Bounding Box
	// public AABB boundingbox(){}


	// -------------------------------------------------------------------------
	// GUI
	public void drawNodes(){
		for(Node n : this.NODES) n.draw();
	}

	public void drawBranches(){
		for(Branch b : this.BRANCHES) b.draw();
	}

	public void draw(){
		stroke(255, 0, 0);
		strokeWeight(10);
		this.drawNodes();

		stroke(255);
		strokeWeight(2);
		this.drawBranches();

	}
}