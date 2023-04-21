## 添加访存指令  

- lb,lbu,lh,lhu  

改动地点：  
- ctrl.v  
  - 增加四个指令翻译码模块，增加LAddr信号  
- RF.v  
  - 根据LAddr更改写回数据  
- sccpu.v  
  - 增加LAddr信号  

## 增加存储指令  

- sb, sh  

改动地点:  
- 拓展Memwrite信号  
- 在dm模块中根据MemWrite信号写入不同长度数据  


## 增加R型指令  