public class Branch{
	private Tree PARENT;
	private Node START, END;
	private ArrayList<Node> NODES;

	// -------------------------------------------------------------------------
	// CONSTRUCTOR
	// create a branch on the tree t, from one node to another
	Branch(Tree t, Node from, Node to){
		this.PARENT = t;
		this.NODES = new ArrayList<Node>();

		this.START = this.registerNode(from);
		this.END = this.registerNode(to);

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
	// GETTERS
	public Node getNode(int index){ return this.NODES.get(index); }
	public Node getFirstNode(){ return this.START; }
	public Node getLastNode(){ return this.END; }
	public Node getRandomNode(){ return this.NODES.get(int(random(this.NODES.size()))); }
	public Node getEnd(){ return this.END; }
	public Node getStart(){ return this.START; }



	// -------------------------------------------------------------------------
	// NODE INSERTION
	// insert a node on the branch, with its position determined by a factor from 0 to 1,
	// 0 being the start of the branch, and 1 its end
	// return the inserted node
	public Node insertNode(float position){
		Vec3D v = this.START.getVector().interpolateTo(this.END.getVector(), position);
		return this.registerNode(new Node(this, v));
	}



	// -------------------------------------------------------------------------
	// MATHS & GEOM HELPERS
	// return the length of the branch
	public float length(){
		return this.START.getVector().distanceTo(this.END.getVector());
	}

	// return the global direction of the branch as a normalized 3D getVector()
	public Vec3D heading(){
		return this.END.getVector().sub(this.START.getVector()).normalize();
	}



	// -------------------------------------------------------------------------
	// GUI
	public void draw(){
		line(this.START.getVector().x, this.START.getVector().y, this.START.getVector().z, this.END.getVector().x, this.END.getVector().y, this.END.getVector().z);
	}
}