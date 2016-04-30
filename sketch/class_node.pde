public class Node{
	private ArrayList<Branch> PARENTS, ROOT_OF;
	private Branch LEAF_OF ;
	private Vec3D vector;

	// -------------------------------------------------------------------------
	// CONSTRUCTOR
	// create a new node on branch b with the position v
	Node(Branch b, Vec3D v){
		if(this.PARENTS == null) this.PARENTS = new ArrayList<Branch>();
		if(this.ROOT_OF == null) this.ROOT_OF = new ArrayList<Branch>();
		this.registerBranchAsParent(b);
		this.vector = v;
	}

	// create a new orphan node with the position v
	// this orphan will be recognized in the constructor of its branch
	Node(Vec3D v){
		if(this.PARENTS == null) this.PARENTS = new ArrayList<Branch>();
		if(this.ROOT_OF == null) this.ROOT_OF = new ArrayList<Branch>();
		this.vector = v;
	}



	// -------------------------------------------------------------------------
	// PROPAGATION
	// add a new node to the branch list AND the branch's tree list
	// return true if the branch has been registered as a node's parent
	public boolean registerBranchAsParent(Branch b){
		if(!this.PARENTS.contains(b)){
			this.PARENTS.add(b);
			return true;
		}else return false;
	}

	// tell the current node that it is a leaf/root of a specific branch
	// return the current node
	public Node registerAsLeaf(Branch b){ this.LEAF_OF = b; return this; }
	public Node registerAsRoot(Branch b){ this.ROOT_OF.add(b); return this; }



	// -------------------------------------------------------------------------
	// GETTERS
	public ArrayList<Branch> getParents(){ return this.PARENTS; }
	public Vec3D getVector(){ return this.vector; }



	// -------------------------------------------------------------------------
	// DATA
	public boolean isLeaf(){ return this.LEAF_OF != null; }
	public boolean isRoot(){ return this.ROOT_OF.size() >= 1; }
	public boolean isLeafOf(Branch b){ return this.LEAF_OF == b; }
	public boolean isRootOf(Branch b){ return this.ROOT_OF.contains(b); }


	// -------------------------------------------------------------------------
	// GUI
	public void draw(){
		point(this.vector.x, this.vector.y, this.vector.z);
	}
}