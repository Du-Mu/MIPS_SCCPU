## 添加访存指令  

- lb,lbu,lh,lhu  

### 改动地点  
  
- ctrl.v  
  - 增加四个指令翻译码模块，增加LAddr信号  
- RF.v  
  - 根据LAddr更改写回数据  
- sccpu.v  
  - 增加LAddr信号  

## 增加存储指令  

- sb, sh  

### 改动地点  
    
- 拓展Memwrite信号  
- 在dm模块中根据MemWrite信号写入不同长度数据  


## 增加R型指令   

- nor,xor,srlv,sllv,srav 
- bne  

### 改动地点

- bne只要修改NPCOp和ALUOp两个信号量赋值  
- nor,xor,srlv,sllv,srav主要改动ALUOp信号和ALU内容  

## 增加i型指令  

- slti, andi只需要修改ctrl的信号赋值即可  
- lui在改变信号量的基础上还需要修改ALU  

