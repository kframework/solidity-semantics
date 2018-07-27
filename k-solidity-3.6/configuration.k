
requires "solidity-syntax.k"

module CONFIGURATION

imports SOLIDITY-SYNTAX



 syntax KResult ::= Int | Bool | String | Uint | Byte | Fixed | Ufixed | Msg

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
                <funCon> true </funCon>
                <Continue> false </Continue>
                <forInit> true </forInit>
                
                
                <contracts>
                  <contractnum> 0:Int </contractnum>
	             <contract multiplicity = "*">
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
                        <length> .Map </length>
                        <dim> 1:Int </dim>
                        <vdim> .Map </vdim>
                        
                        <inheritance> .K </inheritance>
                        <contractbody> .K </contractbody>
                        
                        <events>
                           <event multiplicity = "*">
                              <ename> .K </ename>
                              <eparameters> .K </eparameters>
                           </event>
                        </events>
                     
                        <modifiers>
                           <modifier multiplicity = "*">
                              <mname> .K </mname>
                              <mparameters> .K </mparameters>
                              <condition> .K </condition>
                           </modifier>
                        </modifiers>
                        <usingfors>
                           <usingfor multiplicity = "*">
                              <lname> .K </lname>
                              <type> .K </type>
                              <vname> .K </vname>
                           </usingfor>
                        </usingfors>
                    <structs>
                     <struct multiplicity = "*">
                        <sname> .K </sname>
                        <vardec> .K </vardec>
                               
                     </struct>
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

                       <constructor> 0:Int </constructor>
                     </contract>    
	          </contracts>

                  <functions>
                     <function multiplicity = "*" color="blue"> 
                        <fId color="black"> 0:Int </fId>
                        <inputparameters color="green"> .Parameters </inputparameters>
                        <outputparameters color="green"> .Parameters </outputparameters>
                        <body color="orange"> .K </body>
                        <FunQuantifiers> .K </FunQuantifiers>
                        <return> .K </return>
                        <FunCon> true </FunCon>
                     </function>
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
                        <memory> .Map </memory>
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








