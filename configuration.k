
requires "solidity-syntax.k"

module CONFIGURATION

imports SOLIDITY-SYNTAX


  //syntax KResult ::= Value | String | Uint | Byte | Fixed | Ufixed | Msg

 configuration
              <T color="yellow">

                <threads color="orange">
                  <thread multiplicity="*" color="blue">
                      <k color="green"> $PGM:SourceUnit </k> 
                      <env color="LightSkyBlue"> .Map </env>
	              <contractStack> ListItem(-1) </contractStack>
                      <functionStack> .List </functionStack>
                      <newStack> .List </newStack>
                  </thread>
                </threads>

                <store color="red"> .Map </store>


                <vposition> 1:Int </vposition>
                <loopCon> true </loopCon>
                <funCond> true </funCond>
                <Continue> false </Continue>
                <forInit> true </forInit>
                
                
                <contracts>
                  <contractnum> 0:Int </contractnum>
	             <Contract multiplicity = "*">
	                <cname> .K  </cname>
    
                        <cId> (-1):Int </cId>
                        <cfunction> .Map </cfunction> 
                        
	                <vnum> 0:Int </vnum>  
                        <vId> .Map </vId> 
                        <variables> .Map </variables>
                        <typename> .Map </typename>
                               
                        <cstore> .Map </cstore>
                        <cLocation> .Map </cLocation>
                        <dtype> .Map </dtype>
                        <dstore> .Map </dstore>
                        <Length> .Map </Length>
                        <dim> 1:Int </dim>
                        <vdim> .Map </vdim>
                        
                        <inheritance> .K </inheritance>
                        <contractbody> .K </contractbody>
                        
                        <events>
                           <Event multiplicity = "*">
                              <ename> .K </ename>
                              <eparameters> .K </eparameters>
                           </Event>
                        </events>
                     
                        <modifiers>
                           <Modifier multiplicity = "*">
                              <mname> .K </mname>
                              <mparameters> .K </mparameters>
                              <condition> .K </condition>
                           </Modifier>
                        </modifiers>
                        <usingfors>
                           <usingfor multiplicity = "*">
                              <lname> .K </lname>
                              <type> .K </type>
                              <vname> .K </vname>
                           </usingfor>
                        </usingfors>
                    <structs>
                     <Struct multiplicity = "*">
                        <sname> .K </sname>
                        <vardec> .K </vardec>
                     </Struct>
                    </structs>
                    <structinstances>
                       <cntstructinstance> 0:Int </cntstructinstance>
                  
                       <structinstance multiplicity = "*">
                         <structname> .K </structname>
                         <iname> .K </iname>
                         <iId> (-1):Int </iId>
                         <isnum> 0:Int </isnum>
                         <ivariables> .Map </ivariables>
                      
                      </structinstance>
                    </structinstances>
                     <baseaddress> .Map </baseaddress>

                      <arrays>
                      
                         <array multiplicity = "*">
                            <aname> .K </aname>
                            <dnum> 1:Int </dnum>
                            <dimensions>  .Map </dimensions>
                          </array>
                       </arrays>
                       <newInstances> .List </newInstances>
                       <constructor> 0:Int </constructor>
                     </Contract>    
	          </contracts>

                  <functions>
                     <Function multiplicity = "*" color="blue"> 
                        <fId color="black"> 0:Int </fId>
                        <inputparameters> .FParameters </inputparameters>
                        <outputparameters> .FParameters </outputparameters>
                        <body color="orange"> .K </body>
                        <FunQuantifiers> .K </FunQuantifiers>
                        <Return> .K </Return>
                        <FunCon> true:Expression </FunCon>
                     </Function>
                     <cntfunction> 0:Int </cntfunction>
                  </functions>

                  <contractInstances>
	             <cntContracts> 0:Int </cntContracts>
	             <contractInstance multiplicity = "*">
	                <ctId> (-1):Int </ctId>
                        <ctname> .K </ctname>
                        <ctnum> 0:Int </ctnum>
                        <ctvId> .Map </ctvId>
	                <ctContext> .Map </ctContext>
                        <ctType> .Map </ctType>
                        <ctstore> .Map </ctstore>
                        <ctLocation> .Map </ctLocation>
                        <tempContext> .Map </tempContext>
                        <tempStore> .Map </tempStore>
                        <tempdistore> .Map </tempdistore>
                        <tempmemory> .Map </tempmemory>
                        <ditype> .Map </ditype>
                        <distore> .Map </distore>
                        <Memory> .Map </Memory>
                        <ilength> .Map </ilength>
                        <idim> 1:Int </idim>
                        <ivdim> .Map </ivdim>
                        <ibaseaddress> .Map </ibaseaddress>
                        <iarrays>
                         <iarray multiplicity = "*">
                            <ianame> .K </ianame>
                            <idnum> 1:Int </idnum>
                            <idimensions>  .Map </idimensions>
                          </iarray>
                       </iarrays>
                         
	             </contractInstance>
	          </contractInstances>

                  <transactions>
                     <cnttran> 1:Int </cnttran>
	             <trancomputation> 0 |-> "Main"  </trancomputation>
	          </transactions>
                  <Msg> .K </Msg>
                  <MsgStack> .List </MsgStack>

                 </T>

endmodule








