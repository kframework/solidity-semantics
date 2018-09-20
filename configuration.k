requires "solidity-syntax.k"

module CONFIGURATION
    imports SOLIDITY-SYNTAX

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
            <exeCon> true </exeCon>
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
                <typeName> .Map </typeName>
                <cstore> .Map </cstore>
                <cLocation> .Map </cLocation>
                <dtype> .Map </dtype>
                <dstore> .Map </dstore>
                <Length> .Map </Length>
                <dim> 1:Int </dim>
                <vdim> .Map </vdim>
                <inheritance> .K </inheritance>
                <contractBody> .K </contractBody>
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
                    <cntStructInstance> 0:Int </cntStructInstance>
                        <structInstance multiplicity = "*">
                            <structName> .K </structName>
                            <iname> .K </iname>
                            <iId> (-1):Int </iId>
                            <isnum> 0:Int </isnum>
                            <ivariables> .Map </ivariables>
                        </structInstance>
                </structinstances>
                <baseAddress> .Map </baseAddress>
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
                <inputParameters> .FParameters </inputParameters>
                <outputParameters> .FParameters </outputParameters>
                <body color="orange"> .K </body>
                <FunQuantifiers> .K </FunQuantifiers>
                <FunCon> true:Expression </FunCon>
            </Function>
            <cntFunction> 0:Int </cntFunction>
        </functions>
        <contractInstances>
            <cntContracts> 0:Int </cntContracts>
            <contractInstance multiplicity = "*">
                <ctId> (-1):Int </ctId>
                <ctName> .K </ctName>
                <ctNum> 0:Int </ctNum>
                <ctVId> .Map </ctVId>
                <ctContext> .Map </ctContext>
                <globalContext> .Map </globalContext>
                <ctType> .Map </ctType>
                <ctStore> .Map </ctStore>
                <ctLocation> .Map </ctLocation>
                <tempContext> .Map </tempContext>
                <tempStore> .Map </tempStore>
                <tempIdStore> .Map </tempIdStore>
                <tempMemory> .Map </tempMemory>
                <idType> .Map </idType>
                <idStore> .Map </idStore>
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
        <binaryConversions>
            <binaryConversion multiplicity = "*">
                <decimal> .K </decimal>
                <digitNum> 0:Int </digitNum>
                <digits> .Map </digits>
                <binary> 0:Int </binary>
            </binaryConversion>
        </binaryConversions>
        <transactions>
            <cnttran> 1:Int </cnttran>
            <tranComputation> 0 |-> "Main"  </tranComputation>
        </transactions>
        <Msg> .K </Msg>
        <MsgStack> .List </MsgStack>
        <uintSize>
            uint |-> 256
            uint8 |-> 8
            uint16 |-> 16
            uint24 |-> 24
            uint32 |-> 32
            uint40 |-> 40
            uint48 |-> 48
            uint56 |-> 56
            uint64 |-> 64
            uint72 |-> 72
            uint80 |-> 80
            uint88 |-> 88
            uint96 |-> 96
            uint104 |-> 104
            uint112 |-> 112
            uint120 |-> 120
            uint128 |-> 128
            uint136 |-> 136
            uint144 |-> 144
            uint152 |-> 152
            uint160 |-> 160
            uint168 |-> 168
            uint176 |-> 176
            uint184 |-> 184
            uint192 |-> 192
            uint200 |-> 200
            uint208 |-> 208
            uint216 |-> 216
            uint224 |-> 224
            uint232 |-> 232
            uint240 |-> 240
            uint248 |-> 248
            uint256 |-> 256
        </uintSize>
        <outputLog stream="stdout"> .List </outputLog>
    </T>
endmodule
