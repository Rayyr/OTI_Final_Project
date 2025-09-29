class bmu_subscriber extends uvm_subscriber #(bmu_sequence_item); 

  `uvm_component_utils(bmu_subscriber)
    bmu_sequence_item sub; 
    int c=0;//to keep up the num of packets due to the issue of sunch so get the correct result as i have came up with it reqiures at least 3 cycles !!

 
 covergroup bmu_cpop_coverage; 
 
  a_in: coverpoint sub.a_in {
    bins zero={0};
    bins ones={-1};
    bins alter_v1={1431655765};//32'h55555555
    bins alter_v2={-1431655766};//32'hAAAAAAAA
    bins least_2_bytes={65535}; //32'h0000ffff
    bins most_2_bytes={-65536}; //32'hhffff0000
      //we dont have overlap
  }

  
  //so here i need to cover the conflict data path ( any wrong data path not nessecary i covered in the sequence ) , reading data path , and the correct cpop data path
count_ap : coverpoint $countones(sub.ap) {
  bins conflict_data_path = {[2:$]}; //1 bin for all
  bins valid_cpop={1} iff (sub.ap.cpop == 1);
}

 
csr_ren_in:coverpoint sub.csr_ren_in {bins valid_reading={0};
bins conflict_reading={1};}


cross_valid_cpop:cross csr_ren_in,count_ap{//4(2*2)bins
 
  bins valid_op=binsof(csr_ren_in) intersect {0} && //valid cpop
   binsof(count_ap.valid_cpop);


 bins invalid_conflict_reading=binsof(csr_ren_in) intersect {1} 
&& binsof(count_ap.valid_cpop) ; //reading with cpop

 bins invalid_conflict_data_path=binsof(csr_ren_in) intersect {0} 
&& binsof(count_ap.conflict_data_path) ; //invalid cpop data path

ignore_bins double_conflict = binsof(csr_ren_in) intersect {1} &&
                                 binsof(count_ap.conflict_data_path)  ;
}


//cpop : ones count are ranged from 0-32 so other values are useless (33-2^32)
result_ff: coverpoint sub.result_ff{bins ones_count[]={[0:32]};} //32 bins 
error: coverpoint sub.error; 
rst_l:coverpoint sub.rst_l;

endgroup 




covergroup bmu_grev_coverage;

b_in:coverpoint sub.b_in[4:0] { //5bit == 0-31
  bins valid_b_in={24};
  bins invalid_b_in=default;//0-23 & 25-31
 
}


a_in:coverpoint sub.a_in{
  bins zero={0};
  bins ones={-1};
  bins alter_v1={1431655765};//32'h55555555
  bins alter_v2={-1431655766};//32'hAAAAAAAA
  bins least_2_bytes={22010}; //32'h000055fa
  bins most_2_bytes={-264241152}; //32'hf0400000
  bins symmetry_2_by_2B= { [32'h00000000 : 32'hFFFFFFFF] }  iff (sub.a_in[31:16]==sub.a_in[15:0]); //32'h2410_2410;  
  bins symmetry_1_by_1B={ [32'h00000000 : 32'hFFFFFFFF] } iff ((sub.a_in[7:0]== sub.a_in[15:8]) && (sub.a_in[7:0]== sub.a_in[23:16]) && (sub.a_in[7:0] == sub.a_in[31:24] ));//32'hf0f0f0f0
  bins symmetry_1_by_1B_v2={ [32'h00000000 : 32'hFFFFFFFF] } iff ((sub.a_in[7:0]==sub.a_in[31:24]) && (sub.a_in[15:8]==sub.a_in[23:16]));//32'h23f0_f023
  //we have overlap
}

count_ap : coverpoint $countones(sub.ap) {
  bins conflict_data_path = {[2:$]}; //1 bin for all
  bins valid_grev={1} iff (sub.ap.grev == 1);
}

 
csr_ren_in:coverpoint sub.csr_ren_in {bins valid_reading={0};
bins conflict_reading={1};}


cross_valid_grev:cross csr_ren_in,count_ap{//4(2*2)bins
 
  bins valid_op=binsof(csr_ren_in) intersect {0} && //valid grev
   binsof(count_ap.valid_grev);


 bins invalid_conflict_reading=binsof(csr_ren_in) intersect {1} 
&& binsof(count_ap.valid_grev) ; //reading with grev

 bins invalid_conflict_data_path=binsof(csr_ren_in) intersect {0} 
&& binsof(count_ap.conflict_data_path) ; //invalid grev data path


ignore_bins double_conflict = binsof(csr_ren_in) intersect {1} &&
                                 binsof(count_ap.conflict_data_path)  ;
}



error: coverpoint sub.error; 
rst_l:coverpoint sub.rst_l;

endgroup





covergroup bmu_max_coverage;

error:coverpoint sub.error;
rst_l:coverpoint sub.rst_l;

csr_ren_in:coverpoint sub.csr_ren_in {bins valid_reading={0};
bins conflict_reading={1};}

a_in:coverpoint sub.a_in{
  bins positive={[0:$]};
  bins negative={[-2147483648:-1]}; 
}

b_in:coverpoint sub.b_in{
  bins positive={[0:$]};
  bins negative={[-2147483648:-1]};
}

count_ap:coverpoint $countones(sub.ap){
  bins conflict_data_path = {[3:$]}; //1 bin for all
  bins valid_max={2} iff (sub.ap.max == 1 && sub.ap.sub==1);
}


cross_valid_max:cross csr_ren_in,count_ap{//4(2*2)bins
 
  bins valid_op=binsof(csr_ren_in) intersect {0} && //valid max
   binsof(count_ap.valid_max);


 bins invalid_conflict_reading=binsof(csr_ren_in) intersect {1} 
&& binsof(count_ap.valid_max) ; //reading with max

 bins invalid_conflict_data_path=binsof(csr_ren_in) intersect {0} 
&& binsof(count_ap.conflict_data_path) ; //invalid max data path


ignore_bins double_conflict = binsof(csr_ren_in) intersect {1} &&
                                 binsof(count_ap.conflict_data_path)  ;
}


//verify directly about DUT behavior
result_ff:coverpoint sub.result_ff{
  bins proper_max={1} iff (((sub.result_ff == sub.b_in) && ((sub.b_in >sub.a_in)))||((sub.result_ff == sub.a_in) && ((sub.a_in >sub.b_in))));
  bins wrong_max =default;
}

endgroup



covergroup  bmu_ctz_coverage;

rst_l:coverpoint sub.rst_l;
error:coverpoint sub.error;

csr_ren_in:coverpoint sub.csr_ren_in {bins valid_reading={0};
bins conflict_reading={1};}


a_in:coverpoint sub.a_in{
  bins zero={0};
  bins ones={-1};
  bins odd={[-2147483648:2147483647]} iff (sub.a_in[0]==1); 
  bins even_consecutive_zeroes={[-2147483648:2147483647]} iff ((sub.a_in[8:0]==0 && sub.a_in[9]==1)||//9bits
  (sub.a_in[15:0]==0 && sub.a_in[16]==1)||//16 bits
  (sub.a_in[7:0]==0 && sub.a_in[8]==1)||//8bits
  (sub.a_in[6:0]==0 && sub.a_in[7]==1)||//7bits
  (sub.a_in[5:0]==0 && sub.a_in[6]==1)||//6bits
  (sub.a_in[4:0]==0 && sub.a_in[5]==1)||//5bits
  (sub.a_in[3:0]==0 && sub.a_in[4]==1)||//4bits
  (sub.a_in[2:0]==0 && sub.a_in[3]==1)||//3bits
  (sub.a_in[1:0]==0 && sub.a_in[2]==1)||//2bits
   (sub.a_in[0]==0 && sub.a_in[1]==1) );//1bit
}


count_ap:coverpoint $countones(sub.ap){
  bins conflict_data_path = {[2:$]}; //1 bin for all
  bins valid_ctz={1} iff (sub.ap.ctz == 1);
}



cross_valid_ctz:cross csr_ren_in,count_ap{//4(2*2)bins
 
  bins valid_op=binsof(csr_ren_in) intersect {0} && //valid ctz
   binsof(count_ap.valid_ctz);


 bins invalid_conflict_reading=binsof(csr_ren_in) intersect {1} 
&& binsof(count_ap.valid_ctz) ; //reading with ctz

 bins invalid_conflict_data_path=binsof(csr_ren_in) intersect {0} 
&& binsof(count_ap.conflict_data_path) ; //invalid ctz data path


ignore_bins double_conflict = binsof(csr_ren_in) intersect {1} &&
                                 binsof(count_ap.conflict_data_path)  ;
}


result_ff:coverpoint sub.result_ff{
  bins all_possible_results[]={[0:32]};
}

endgroup









covergroup bmu_slt_coverage;

rst_l:coverpoint sub.rst_l;
error:coverpoint sub.error;

unsign:coverpoint sub.ap.unsign{
  bins unsign_slt={1};
  bins sign_slt={0};
}

csr_ren_in:coverpoint sub.csr_ren_in {bins valid_reading={0};
bins conflict_reading={1};}


a_in:coverpoint sub.a_in{
  bins positive={[0:$]};
  bins negative={[-2147483648:-1]}; 
}

b_in:coverpoint sub.b_in{
  bins positive={[0:$]};
  bins negative={[-2147483648:-1]}; 
}


count_ap:coverpoint $countones(sub.ap){
  bins conflict_signed_data_path = {[3:$]}; //1 bin for all
  bins conflict_unsigned_data_path = {[4:$]}; //1 bin for all
  bins valid_signed_slt={2} iff (sub.ap.slt==1  &&  sub.ap.sub==1);
  bins valid_unsigned_slt={3} iff  (sub.ap.slt==1   &&   sub.ap.sub==1   &&   sub.ap.unsign==1);
}



cross_valid_slt:cross csr_ren_in,count_ap{//8(4*2)bins
 
 
  bins valid_signed_op=binsof(csr_ren_in) intersect {0} && //valid signed slt
   binsof(count_ap.valid_signed_slt);

  bins valid_unsigned_op=binsof(csr_ren_in) intersect {0} && //valid unsigned slt
   binsof(count_ap.valid_unsigned_slt);




 bins invalid_signed_conflict_reading=binsof(csr_ren_in) intersect {1} 
&& binsof(count_ap.valid_signed_slt) ; //reading with signed slt

 


 bins invalid_signed_conflict_data_path=binsof(csr_ren_in) intersect {0} 
&& binsof(count_ap.conflict_signed_data_path) ; //invalid signed slt data path

 bins invalid_unsigned_conflict_data_path=binsof(csr_ren_in) intersect {0} 
&& binsof(count_ap.conflict_unsigned_data_path) ; //invalid unsigned slt data path




ignore_bins double_conflict = binsof(csr_ren_in) intersect {1} &&
                                 binsof(count_ap.conflict_unsigned_data_path); //actually 2 bins are being ignored out of 8 bins

ignore_bins xx=binsof(csr_ren_in) intersect {1} && binsof(count_ap.conflict_signed_data_path);

ignore_bins yy=binsof(csr_ren_in) intersect {1} && binsof(count_ap.valid_unsigned_slt);

}


//verify the DUT result behavior directlly so it is not enough to cover the hit values but the full scenario which heads to this result ... ( concept of verification to cleck teh cases you covered with their full path)
result_ff:coverpoint sub.result_ff{
  bins proper_slt={[−2147483648:2147483647]} iff(((sub.result_ff==1 && sub.ap.unsign==0 && sub.a_in<sub.b_in)||(sub.result_ff==0 && sub.ap.unsign==0 && sub.a_in>sub.b_in))
                         || ((sub.result_ff==1 && sub.ap.unsign==1 && $unsigned(sub.a_in)<$unsigned(sub.b_in))||(sub.result_ff==0 &&sub.ap.unsign==1&& $unsigned(sub.a_in)>$unsigned(sub.b_in))) );
}

endgroup







covergroup bmu_pack_coverage;

rst_l:coverpoint sub.rst_l;
error:coverpoint sub.error;

 
csr_ren_in:coverpoint sub.csr_ren_in {bins valid_reading={0};
bins conflict_reading={1};}


a_in:coverpoint sub.a_in{
  bins zero={0};
  bins ones ={-1};
  bins others = default;
  
}

b_in:coverpoint sub.b_in{
  bins zero={0};
  bins ones ={-1};
  bins others = default ;
}


count_ap:coverpoint $countones(sub.ap){
  bins conflict_data_path = {[2:$]}; //1 bin for all
  bins valid_pack={1} iff  (sub.ap.pack==1);
}



cross_valid_pack:cross csr_ren_in,count_ap{//4(2*2)bins
 
  bins valid_op=binsof(csr_ren_in) intersect {0} && //valid pack
   binsof(count_ap.valid_pack);


 bins invalid_conflict_reading=binsof(csr_ren_in) intersect {1} 
&& binsof(count_ap.valid_pack) ; //reading with pack

 

 bins invalid_conflict_data_path=binsof(csr_ren_in) intersect {0} 
&& binsof(count_ap.conflict_data_path) ; //conflict data path

 
ignore_bins double_conflict = binsof(csr_ren_in) intersect {1} &&
                                 binsof(count_ap.conflict_data_path); 

}


//verify directly about DUT result behavior
result_ff:coverpoint sub.result_ff{
  bins proper_pack={1} iff (sub.result_ff[31:16]==sub.b_in[15:0] && sub.result_ff[15:0]==sub.a_in[15:0]);
  bins wrong_pack =default;
}

endgroup




covergroup bmu_siext_b_coverage;

rst_l:coverpoint sub.rst_l;
error:coverpoint sub.error;

csr_ren_in:coverpoint sub.csr_ren_in{
  bins valid_reading={0};
  bins conflict_reading={1};
}

count_ap:coverpoint $countones(sub.ap){
  bins valid_siext_b={1} iff (sub.ap.siext_b==1);
  bins conflict_data_path={[2:$]};//1 bin for all possiple conflict data paths 
}


cross_valid_siext_b:cross count_ap,csr_ren_in{

  bins valid_op=binsof(csr_ren_in.valid_reading) && binsof(count_ap.valid_siext_b);
  bins invalid_conflict_reading=binsof(csr_ren_in.conflict_reading) && binsof(count_ap.valid_siext_b);
  bins invalid_conflict_data_path=binsof(count_ap.conflict_data_path) && binsof(csr_ren_in.valid_reading);

  ignore_bins double_conflict=binsof(count_ap.conflict_data_path)&& binsof(csr_ren_in.conflict_reading);
}


a_in:coverpoint sub.a_in{

bins comb_00={[1:2147483647]} iff (sub.a_in[31]==0 && sub.a_in[7]==0);//pos value 
bins comb_11={[-2147483648:-1]} iff (sub.a_in[31]==1 && sub.a_in[7]==1);//neg value 
bins comb_01={[1:2147483647]} iff (sub.a_in[31]==0 && sub.a_in[7]==1);
bins comb_10={[-2147483648:-1]} iff (sub.a_in[31]==1 && sub.a_in[7]==0);

//bins others =default;//impossible to be hit ( logically !)
}


//this will only will cover the result value but in fact here we need more details thats why iff (sub.result_ff[31:8]==24'hffffff) is being commented .... 
result_ff:coverpoint sub.result_ff{
  bins ones={[-2147483648:-1]} iff (sub.a_in[7]==1); // iff (sub.result_ff[31:8]==24'hffffff);
  bins zeros={[1:2147483647]} iff (sub.a_in[7]==0);//iff (sub.result_ff[31:8]==24'h000000);
}

endgroup






covergroup bmu_ror_coverage;

rst_l:coverpoint sub.rst_l;
error:coverpoint sub.error;


csr_ren_in:coverpoint sub.csr_ren_in{
  bins valid_reading={0};
  bins conflict_reading={1};
}

count_ap:coverpoint $countones(sub.ap){
  bins valid_ror={1} iff (sub.ap.ror==1);
  bins conflict_data_path={[2:$]};//1 bin for all possiple conflict data paths 
}


cross_valid_ror:cross count_ap,csr_ren_in{

  bins valid_op=binsof(csr_ren_in.valid_reading) && binsof(count_ap.valid_ror);
  bins invalid_conflict_reading=binsof(csr_ren_in.conflict_reading) && binsof(count_ap.valid_ror);
  bins invalid_conflict_data_path=binsof(count_ap.conflict_data_path) && binsof(csr_ren_in.valid_reading);

  ignore_bins double_conflict=binsof(count_ap.conflict_data_path)&& binsof(csr_ren_in.conflict_reading);
}


b_in:coverpoint sub.b_in[4:0]{
  bins all_posiibilites[]={[0:31]};
}

a_in:coverpoint sub.a_in;
result_ff:coverpoint sub.result_ff;

cross_b_result:cross a_in,result_ff{
  bins no_change=binsof(a_in) && binsof(result_ff) iff(sub.b_in[4:0]==0);//record how many times a= result == Creates a cross bin that counts when a_in == result_ff.
  //this means we have 2^32 *2 possibilities as follow : 
  // a        resukt b
  //1          v     b
  //2          v     b
  //3          v     b
  //...      ....    b
  //a         a      0
}

endgroup








covergroup bmu_binv_coverage;

rst_l:coverpoint sub.rst_l;
error:coverpoint sub.error;


csr_ren_in:coverpoint sub.csr_ren_in{
  bins valid_reading={0};
  bins conflict_reading={1};
}

count_ap:coverpoint $countones(sub.ap){
  bins valid_binv={1} iff (sub.ap.binv==1);
  bins conflict_data_path={[2:$]};//1 bin for all possiple conflict data paths 
}


cross_valid_binv:cross count_ap,csr_ren_in{

  bins valid_op=binsof(csr_ren_in.valid_reading) && binsof(count_ap.valid_binv);
  bins invalid_conflict_reading=binsof(csr_ren_in.conflict_reading) && binsof(count_ap.valid_binv);
  bins invalid_conflict_data_path=binsof(count_ap.conflict_data_path) && binsof(csr_ren_in.valid_reading);

  ignore_bins double_conflict=binsof(count_ap.conflict_data_path)&& binsof(csr_ren_in.conflict_reading);
}


b_in:coverpoint sub.b_in[4:0]{
  bins all_posiibilites[]={[0:31]};
}
 

a_in_msb:coverpoint sub.a_in[31];
a_in_lsb:coverpoint sub.a_in[0];

res_msb:coverpoint sub.result_ff[31];
res_lsb:coverpoint sub.result_ff[0];


cross_a_res_l:cross a_in_lsb,res_lsb{ //4 cases : 00 , 01 10 11 so i will manually define them  them since i need only the transition cases ! so the others asln will not ever be nit ( logically)

    bins zero_one = binsof(a_in_lsb) intersect {0} &&
                    binsof(res_lsb) intersect {1} iff (sub.b_in[4:0]==0);
 
   bins one_zero = binsof(a_in_lsb) intersect {1} &&
                    binsof(res_lsb) intersect {0} iff (sub.b_in[4:0]==0);

    ignore_bins x=binsof(a_in_lsb) intersect {1} && binsof(res_lsb) intersect {1};
    ignore_bins xx=binsof(a_in_lsb) intersect {0} && binsof(res_lsb) intersect {0};

 //   ignore_bins n=default;
}


cross_a_res_m:cross a_in_msb,res_msb{//4 cases : 00 , 01 10 11 so i will manually define them  them since i need only the transition cases ! so the others asln will not ever be nit ( logically)

    bins zero_one = binsof(a_in_msb) intersect {0} &&
                    binsof(res_msb) intersect {1} iff (sub.b_in[4:0]==5'b11111);
  

   bins one_zero = binsof(a_in_msb) intersect {1} &&
                    binsof(res_msb) intersect {0} iff (sub.b_in[4:0]==5'b11111);

   ignore_bins x=binsof(a_in_msb) intersect {1} && binsof(res_msb) intersect {1};
    ignore_bins xx=binsof(a_in_msb) intersect {0} && binsof(res_msb) intersect {0};
}

endgroup






covergroup bmu_sh2add_coverage;

rst_l:coverpoint sub.rst_l;
error:coverpoint sub.error;


csr_ren_in:coverpoint sub.csr_ren_in{
  bins valid_reading={0};
  bins conflict_reading={1};
}

count_ap:coverpoint $countones(sub.ap){
  bins valid_sh2add={2} iff (sub.ap.sh2add==1 && sub.ap.zba==1);
  bins conflict_data_path={[3:$]};//1 bin for all possiple conflict data paths 
}


cross_valid_sh2add:cross count_ap,csr_ren_in{

  bins valid_op=binsof(csr_ren_in.valid_reading) && binsof(count_ap.valid_sh2add);
  bins invalid_conflict_reading=binsof(csr_ren_in.conflict_reading) && binsof(count_ap.valid_sh2add);
  bins invalid_conflict_data_path=binsof(count_ap.conflict_data_path) && binsof(csr_ren_in.valid_reading);

  ignore_bins double_conflict=binsof(count_ap.conflict_data_path)&& binsof(csr_ren_in.conflict_reading);
}


a_in:coverpoint sub.a_in{
  bins zero={0};
  bins ones={-1};
  bins max={2147483647};
  bins min={-2147483648};
  bins bit_29_one={[-2147483648:$]} iff (sub.a_in[29]==1);//a_in=32'bxx1xxxx...
  bins bit_29_zero={[-2147483648:$]} iff (sub.a_in[29]==0);//a_in=32'bxx0xxxx...
  //bins others_random=default;//impossiple to be hot logically due to bit29 bins .. !!
}
 
b_in:coverpoint sub.b_in{
 bins zero={0};
 bins ones={-1};
 bins max={2147483647};
 bins min={-2147483648};
 bins others_random=default;
}
 

cross_a_b_error:cross a_in,b_in,error{//2*7*5 bins 
  bins underflow=binsof(a_in.bit_29_one)&&binsof(error.auto) intersect {1} && binsof(b_in.min);
  bins overflow=binsof(a_in.bit_29_zero)&&binsof(error.auto) intersect {1} &&binsof(b_in.max);
  //they not being hit since the dut output (error) is not correct thats why !!! , thats why in coverage we cover the 
  //inputs not outputs due to this issue that we dont know if dut is correct or not ... 
   option.cross_auto_bin_max = 0;//disable auto bins
}
endgroup






covergroup bmu_sra_coverage;

rst_l:coverpoint sub.rst_l;
error:coverpoint sub.error;


csr_ren_in:coverpoint sub.csr_ren_in{
  bins valid_reading={0};
  bins conflict_reading={1};
}

count_ap:coverpoint $countones(sub.ap){
  bins valid_sra={1} iff (sub.ap.sra==1);
  bins conflict_data_path={[2:$]};//1 bin for all possiple conflict data paths 
}


cross_valid_sra:cross count_ap,csr_ren_in{

  bins valid_op=binsof(csr_ren_in.valid_reading) && binsof(count_ap.valid_sra);
  bins invalid_conflict_reading=binsof(csr_ren_in.conflict_reading) && binsof(count_ap.valid_sra);
  bins invalid_conflict_data_path=binsof(count_ap.conflict_data_path) && binsof(csr_ren_in.valid_reading);

  ignore_bins double_conflict=binsof(count_ap.conflict_data_path)&& binsof(csr_ren_in.conflict_reading);
}


a_in:coverpoint sub.a_in{
 
  bins neg={[-2147483648:-1]} ;//a_in=32'b1xxxx...
  bins pos={[1:2147483647]} ;//a_in=32'b0xxxx...
  bins others_random=default;
}
 
b_in:coverpoint sub.b_in[4:0]{
 bins shift_amount[]={[0:31]};
}
 
endgroup





covergroup bmu_srl_coverage;

rst_l:coverpoint sub.rst_l;
error:coverpoint sub.error;


csr_ren_in:coverpoint sub.csr_ren_in{
  bins valid_reading={0};
  bins conflict_reading={1};
}

count_ap:coverpoint $countones(sub.ap){
  bins valid_srl={1} iff (sub.ap.srl==1);
  bins conflict_data_path={[2:$]};//1 bin for all possiple conflict data paths 
}


cross_valid_srl:cross count_ap,csr_ren_in{

  bins valid_op=binsof(csr_ren_in.valid_reading) && binsof(count_ap.valid_srl);
  bins invalid_conflict_reading=binsof(csr_ren_in.conflict_reading) && binsof(count_ap.valid_srl);
  bins invalid_conflict_data_path=binsof(count_ap.conflict_data_path) && binsof(csr_ren_in.valid_reading);

  ignore_bins double_conflict=binsof(count_ap.conflict_data_path)&& binsof(csr_ren_in.conflict_reading);
}


a_in:coverpoint sub.a_in{
  bins all={[-2147483648:2147483647]};
}
 
b_in:coverpoint sub.b_in[4:0]{
 bins shift_amount[]={[0:31]};
}
 //cross_different_scenarioes:cross b_in

 //to test directlly the error scenarioes that the dut detect 
 cross_errors:cross error,count_ap,csr_ren_in{
  bins data_path_error=binsof(error.auto) intersect {1} && binsof(count_ap.conflict_data_path); 
  bins reading_error=binsof(error.auto) intersect {1} && binsof(count_ap.valid_srl) && binsof(csr_ren_in.conflict_reading); 
  
    option.cross_auto_bin_max = 0;//disable auto bins
 }
endgroup






/*

covergroup bmu_lor_coverage;

error:coverpoint sub.error;
rst_l:coverpoint sub.rst_l;

csr_ren_in:coverpoint sub.csr_ren_in{
  bins valid_reading={0};
  bins conflict_reading={1};
}

count_ap:coverpoint $countones(sub.ap){
  bins valid_lor={1} iff (sub.ap.lor==1);
  bins valid_inverted_lor={1} iff (sub.ap.lor==1 && sub.ap.zbb==1);
  bins conflict_lor_data_path={[2:$]};//1 bin for all possiple conflict data paths 
}

count_ap:coverpoint $countones(sub.ap){
  bins conflict_signed_data_path = {[3:$]}; //1 bin for all
  bins conflict_unsigned_data_path = {[4:$]}; //1 bin for all
  bins valid_signed_slt={2} iff (sub.ap.slt==1  &&  sub.ap.sub==1);
  bins valid_unsigned_slt={3} iff  (sub.ap.slt==1   &&   sub.ap.sub==1   &&   sub.ap.unsign==1);
}


cross_valid_sra:cross count_ap,csr_ren_in{

  bins valid_op=binsof(csr_ren_in.valid_reading) && binsof(count_ap.valid_srl);
  bins invalid_conflict_reading=binsof(csr_ren_in.conflict_reading) && binsof(count_ap.valid_srl);
  bins invalid_conflict_data_path=binsof(count_ap.conflict_data_path) && binsof(csr_ren_in.valid_reading);

  ignore_bins double_conflict=binsof(count_ap.conflict_data_path)&& binsof(csr_ren_in.conflict_reading);
}


 endgroup
*/

  function new(string name="bmu_subscriber",uvm_component parent); 
    super.new(name,parent); 
    bmu_cpop_coverage = new(); 
    bmu_grev_coverage=new();
    bmu_max_coverage=new();
    bmu_ctz_coverage=new();
    bmu_slt_coverage=new();
    bmu_pack_coverage=new();
    bmu_siext_b_coverage=new();
    bmu_ror_coverage=new();
    bmu_binv_coverage=new();
    bmu_sh2add_coverage=new();
    bmu_sra_coverage=new();
    bmu_srl_coverage=new();
   // bmu_lor_coverage=new();
    sub = new();
  endfunction 
 
 
function void write (bmu_sequence_item t); //this packet from the monitor ( so it is received from the DUT)
if(c%3==1)begin
 
  sub.a_in = t.a_in; 
  sub.b_in = t.b_in; 
  sub.ap = t.ap; 
  sub.rst_l = t.rst_l; 
  sub.valid_in=t.valid_in;
  sub.scan_mode=t.scan_mode;
  sub.csr_rddata_in=t.csr_rddata_in;
  sub.csr_ren_in=t.csr_ren_in;
  sub.result_ff = t.result_ff;  //from dut
  sub.error = t.error; //from dut
  //$display("error=%b",sub.error);

if(sub.ap.cpop==1 )
  bmu_cpop_coverage.sample(); 

if(sub.ap.grev==1 )
 bmu_grev_coverage.sample();
 
if(sub.ap.max==1)
 bmu_max_coverage.sample();

if(sub.ap.ctz==1)
  bmu_ctz_coverage.sample();

if(sub.ap.slt==1)//we can modify it by adding &&ap.sub==1
bmu_slt_coverage.sample();

if(sub.ap.pack==1)
bmu_pack_coverage.sample();

if(sub.ap.siext_b==1)
bmu_siext_b_coverage.sample();

if(sub.ap.ror==1)
bmu_ror_coverage.sample();

if(sub.ap.binv==1)
bmu_binv_coverage.sample();

if(sub.ap.sh2add==1 &&sub.ap.zba==1)
bmu_sh2add_coverage.sample();

if(sub.ap.sra==1)
bmu_sra_coverage.sample();

if(sub.ap.srl==1)
bmu_srl_coverage.sample();
/*
if(sub.ap.lor==1)
bmu_lor_coverage.sample();
*/

end
c++;
endfunction 
  
  
  
  //after write()
function void report_phase(uvm_phase phase); 
  super.report_phase(phase); 
  `uvm_info(get_type_name(),$sformatf("coverage: %d",bmu_cpop_coverage.get_coverage()), UVM_NONE); 
endfunction 
  
  
endclass 

//NOTE : the covergae almost will = 0% but that doesnot mean that no hit has been detected , no but the idea since i hdont define the bins 
//so the automatic ones will be consdered so taht mean for inputs w will have 2^32 bin !!! the same with each coverpoint so the number of 
//combinations is very very large !! , so the percentage of hitting will be ~=0 so since the overall number of transaction also ~=0
//(at most 20 test case i have !!) so thats why , so the solution simply define my own pins(small ones )with teh values i need to analyze !