class RandcRange;   
	randc bit [15:0] value;
	int max_value;     
	int min_value;

	function new(int min_value=0, int max_value = 10);
		this.max_value = max_value;
		this.min_value = min_value;
	 endfunction
 
	constraint c_value {value inside {[min_value:max_value]};}
 
endclass:RandcRange

//============================================
class UniqueArray; 
	 int max_array_size,max_value, min_value;
 
	rand bit [7:0] a[];
	constraint c_size{a.size() inside {[1:max_array_size]};}



	function new(int max_array_size=2,max_value=2, min_value = 0);
		this.max_array_size=max_array_size;
		this.max_value=max_value;
		this.min_value = min_value;
	endfunction



	function void post_randomize;
		RandcRange rr;
		rr=new(min_value, max_value);       
		foreach(a[i]) begin
			assert (rr.randomize());
			a[i]=rr.value;
		end
	endfunction

	function void display();
		$write("Size:=:",a.size());
		foreach (a[i]) $write("M",a[i]);
		$display;
	endfunction
endclass:UniqueArray

