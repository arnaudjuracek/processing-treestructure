public class Tree{
	private ArrayList<Branch> BRANCHES;
	private ArrayList<Node> NODES;

	public Node ROOT;

	// -------------------------------------------------------------------------
	// CONSTRUCTOR
	// create a trunk from a Vec3D to another
	Tree(Vec3D from, Vec3D to){
		this.NODES = new ArrayList<Node>(); // must be instantiated before the first branch instantiation

		this.ROOT = new Node(from);

		this.BRANCHES = new ArrayList<Branch>();
		this.BRANCHES.add(new Branch(this, ROOT, new Node(to)));
	}



	// -------------------------------------------------------------------------
	// BRANCH GETTERS
	public ArrayList<Branch> getBranches(){ return this.BRANCHES; }
	public Branch getBranch(int index){ return this.BRANCHES.get(index); }
	public Branch getFirstBranch(){ return this.BRANCHES.get(0); }
	public Branch getLastBranch(){ return this.BRANCHES.get(this.BRANCHES.size()-1); }
	public Branch getRandomBranch(){ return this.BRANCHES.get(int(random(this.BRANCHES.size()))); }

	// return the nearest connected branches to another one
	public ArrayList<Branch> getConnectedBranches(Branch from){
		ArrayList<Branch> nearest = new ArrayList<Branch>();
		for(Node n : from.NODES){
			if(n.PARENTS!=null){
				for(Branch b : n.PARENTS){
					if(!nearest.contains(b) && b!=from) nearest.add(b);
				}
			}
		}
		return nearest;
	}



	// -------------------------------------------------------------------------
	// NODE GETTERS
	public ArrayList<Node> getNodes(){ return this.NODES; }
	public Node getNode(int index){ return this.NODES.get(index); }
	public Node getFirstNode(){ return this.NODES.get(0); }
	public Node getLastNode(){ return this.NODES.get(this.NODES.size()-1); }
	public Node getRandomNode(){ return this.NODES.get(int(random(this.NODES.size()))); }
	public Node getRoot(){ return this.ROOT; }

	// return the end nodes of the tree as an array of nodes
	public ArrayList<Node> getEnds(){
		ArrayList<Node> bstarts = new ArrayList<Node>();
		for(Branch b : this.getBranches()) bstarts.add(b.getStart());

		ArrayList<Node> ends = new ArrayList<Node>();
		for(Branch b : this.getBranches()){
			Node end = b.getEnd();
			if(!bstarts.contains(end)) ends.add(b.getEnd());
		}
		return ends;
	}


	// return the nearest node from a 3D vector, no matter on which branch this node is
	public Node getNearestNode(Vec3D from){
		Node nearest = null;
		for(Node n : this.getNodes()){
			if(nearest == null || from.distanceTo(n.vector) < from.distanceTo(nearest.vector)){
				nearest = n;
			}
		}
		return nearest;
	}

	// return the nearest connected node to another one
	public Node getNearestNeighborNode(Node from){
		Node neighbor = null;
		if(from.PARENTS!=null){
			ArrayList<Node> possibleNodes = new ArrayList<Node>();
			for(Branch b : from.PARENTS) for(Node n : b.NODES) possibleNodes.add(n);
			for(Node n : possibleNodes){
				if(neighbor == null || from.vector.distanceTo(n.vector) < from.vector.distanceTo(neighbor.vector)){
					if(n!=from) neighbor = n;
				}
			}
		}
		return neighbor;
	}

	// return the n nearest connected nodes to another one
	public ArrayList<Node> getNearestNeighborNodes(Node from, int n_neighbors){
		ArrayList<Node> neighbors = new ArrayList<Node>();
		if(from.PARENTS!=null){
			ArrayList<Node> possibleNodes = new ArrayList<Node>();
			for(Branch b : from.PARENTS) for(Node n : b.NODES) possibleNodes.add(n);
			for(int i=0; i<n_neighbors; i++){
				Node neighbor = null;
				for(Node n : possibleNodes){
					if(neighbor == null || from.vector.distanceTo(n.vector) < from.vector.distanceTo(neighbor.vector)){
						if(n!=from && !neighbors.contains(n)) neighbor = n;
					}
				}
				if(neighbor != null) neighbors.add(neighbor);
				else break;
			}
		}
		return neighbors;
	}



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