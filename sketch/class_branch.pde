public class Branch{
	private Tree PARENT;
	private Node ROOT, LEAF;
	private ArrayList<Node> NODES;
	private int DEPTH;

	// -------------------------------------------------------------------------
	// CONSTRUCTOR
	// create a branch on the tree t, from one node to another
	Branch(Tree t, Node from, Node to){
		this.PARENT = t;
		this.NODES = new ArrayList<Node>();

		this.ROOT = this.registerNode(from.registerAsRoot(this));
		this.LEAF = this.registerNode(to.registerAsLeaf(this));

		this.registerAsParent();
	}



	// -------------------------------------------------------------------------
	// BACKPROPAGATION
	// if some nodes of the branch are orphan, set their branch parent as this one
	// return true if the branch has been registered as a node's parent
	private boolean registerAsParent(){
		boolean new_registration = false;
		for(Node n : this.NODES){
			if(n.registerBranchAsParent(this)) new_registration = true;
		}
		return new_registration;
	}

	// add a new node to the branch list AND the branch's tree list
	// return the new node
	private Node registerNode(Node n){
		if(!this.PARENT.NODES.contains(n)) this.PARENT.addNode(n);
		if(!this.NODES.contains(n)) this.NODES.add(n);
		return n;
	}



	// -------------------------------------------------------------------------
	// DATA
	// compute how deep this branch is on the tree
	// return the depth level as an int
	public int getDepth(){ return this.DEPTH; }

	// set the depth level of the branch
	// return the branch
	public Branch setDepth(int level){
		this.DEPTH = level;
		return this;
	}


	// -------------------------------------------------------------------------
	// GETTERS
	public ArrayList<Node> getNodes(){ return this.NODES; }
	public Node getNode(int index){ return this.NODES.get(index); }
	public Node getFirstNode(){ return this.ROOT; }
	public Node getLastNode(){ return this.LEAF; }
	public Node getRandomNode(){ return this.NODES.get(int(random(this.NODES.size()))); }
	public Node getLeaf(){ return this.LEAF; }
	public Node getRoot(){ return this.ROOT; }



	// -------------------------------------------------------------------------
	// NODE INSERTION
	// insert a node on the branch, with its position determined by a factor from 0 to 1,
	// 0 being the start of the branch, and 1 its end
	// return the inserted node
	public Node insertNode(float position){
		Vec3D v = this.ROOT.getVector().interpolateTo(this.LEAF.getVector(), position);
		return this.registerNode(new Node(this, v));
	}



	// -------------------------------------------------------------------------
	// MATHS & GEOM HELPERS
	// return the length of the branch
	public float length(){
		return this.ROOT.getVector().distanceTo(this.LEAF.getVector());
	}

	// return the global direction of the branch as a normalized 3D getVector()
	public Vec3D heading(){
		return this.LEAF.getVector().sub(this.ROOT.getVector()).normalize();
	}



	// -------------------------------------------------------------------------
	// GUI
	public void draw(){
		line(this.ROOT.getVector().x, this.ROOT.getVector().y, this.ROOT.getVector().z, this.LEAF.getVector().x, this.LEAF.getVector().y, this.LEAF.getVector().z);
	}
}