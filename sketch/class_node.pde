public class Node{
	public ArrayList<Branch> PARENTS;
	public Vec3D vector;

	// -------------------------------------------------------------------------
	// CONSTRUCTOR
	// create a new node on branch b with the position v
	Node(Branch b, Vec3D v){
		if(this.PARENTS == null) this.PARENTS = new ArrayList<Branch>();
		this.registerBranchAsParent(b);
		this.vector = v;
	}

	// create a new orphan node with the position v
	// this orphan will be recognized in the constructor of its branch
	Node(Vec3D v){
		if(this.PARENTS == null) this.PARENTS = new ArrayList<Branch>();
		this.vector = v;
	}



	// -------------------------------------------------------------------------
	// add a new node to the branch list AND the branch's tree list
	// return true if the branch has been registered as a node's parent
	public boolean registerBranchAsParent(Branch b){
		if(!this.PARENTS.contains(b)){
			this.PARENTS.add(b);
			return true;
		}else return false;
	}



	// -------------------------------------------------------------------------
	// GUI
	public void draw(){
		point(this.vector.x, this.vector.y, this.vector.z);
	}
}