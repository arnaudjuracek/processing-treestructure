public class Tree{
	private ArrayList<Branch> BRANCHES;
	private ArrayList<Node> NODES;
	private Node ROOT;
	private int DEPTH;
	private AABB AABB;

	// -------------------------------------------------------------------------
	// CONSTRUCTOR
	// create a trunk from a Vec3D to another
	Tree(Vec3D from, Vec3D to){
		this.NODES = new ArrayList<Node>(); // must be instantiated before the first branch instantiation

		this.ROOT = new Node(from);
		this.AABB = new AABB();

		this.BRANCHES = new ArrayList<Branch>();
		this.BRANCHES.add(new Branch(this, ROOT, new Node(to)).setDepth(1));

		this.DEPTH = 1;
	}



	// -------------------------------------------------------------------------
	// SETTERS
	public Node addNode(Node n){
		this.NODES.add(n);
		if(this.AABB!=null) this.AABB.includePoint(n.getVector());
		return n;
	}

	public Branch addBranch(Branch b){
		this.BRANCHES.add(b);
		return b;
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
			if(n.getParents()!=null){
				for(Branch b : n.getParents()){
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
	public ArrayList<Node> getLeaves(){
		ArrayList<Node> bstarts = new ArrayList<Node>();
		for(Branch b : this.getBranches()) bstarts.add(b.getRoot());

		ArrayList<Node> ends = new ArrayList<Node>();
		for(Branch b : this.getBranches()){
			Node end = b.getLeaf();
			if(!bstarts.contains(end)) ends.add(b.getLeaf());
		}
		return ends;
	}


	// return the nearest node from a 3D vector, no matter on which branch this node is
	public Node getNearestNode(Vec3D from){
		Node nearest = null;
		for(Node n : this.getNodes()){
			if(nearest == null || from.distanceTo(n.getVector()) < from.distanceTo(nearest.getVector())){
				nearest = n;
			}
		}
		return nearest;
	}

	// return the nearest connected node to another one
	public Node getNearestNeighborNode(Node from){
		Node neighbor = null;
		if(from.getParents()!=null){
			ArrayList<Node> possibleNodes = new ArrayList<Node>();
			for(Branch b : from.getParents()) for(Node n : b.NODES) possibleNodes.add(n);
			for(Node n : possibleNodes){
				if(neighbor == null || from.getVector().distanceTo(n.getVector()) < from.getVector().distanceTo(neighbor.getVector())){
					if(n!=from) neighbor = n;
				}
			}
		}
		return neighbor;
	}

	// return the n nearest connected nodes to another one
	public ArrayList<Node> getNearestNeighborNodes(Node from, int n_neighbors){
		ArrayList<Node> neighbors = new ArrayList<Node>();
		if(from.getParents()!=null){
			ArrayList<Node> possibleNodes = new ArrayList<Node>();
			for(Branch b : from.getParents()) for(Node n : b.NODES) possibleNodes.add(n);
			for(int i=0; i<n_neighbors; i++){
				Node neighbor = null;
				for(Node n : possibleNodes){
					if(neighbor == null || from.getVector().distanceTo(n.getVector()) < from.getVector().distanceTo(neighbor.getVector())){
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
	// INSERTIONS
	// add a new branch to the Tree from a node to another
	// update the tree.depth is needed, but set the depth of the branch anyway
	// return the new branch
	public Branch insertBranch(Node from, Node to){
		if(from.LEAF_OF != null && from.LEAF_OF.getDepth() >= this.DEPTH) this.DEPTH++;

		Branch b = new Branch(this, from, to);
		b.setDepth(this.DEPTH);
		this.addBranch(b);
		return b;
	}

	// insert a node on a specific branch, with its position determined by a factor from 0 to 1,
	// 0 being the start of the branch, and 1 its end
	// return the inserted node
	public Node insertNodeToBranch(Branch branch, float position){
		return branch.insertNode(position);
	}



	// -------------------------------------------------------------------------
	// DATA

	public int getDepth(){ return this.DEPTH; }


	// -------------------------------------------------------------------------
	// MATHS & GEOM HELPERS
	// return the average direction of the tree's branches as a normalized 3D vector
	public Vec3D heading(){
		Vec3D average = new Vec3D();
		for(Branch b : this.getBranches()) average.addSelf(b.heading().scale(b.length()));
		return average.normalize();
	}

	// return the bounding box of the tree as a Axis Align Bounding Box
	public AABB getAABB(){
		return this.AABB; // the AABB is updated in Tree.addNode()
	}

	// return the centroid of the as a 3D vector
	public Vec3D getCentroid(){
		AABB box = this.getAABB();
		return box.getMin().interpolateTo(box.getMax(), .5);
	}


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