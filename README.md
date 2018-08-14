# eth-baccarat
# 以太坊平台百家乐游戏智能合约
 1.实现了智能合约发牌逻辑
 2.实现了智能合约比牌逻辑

 ..* contracts/baccarat4.sol  通过中心服务器调用智能合约发牌（有房间的概念）
 ..* contracts/baccarat5.sol  完全去中心化的版本，用户可以自己调用发牌开牌，直接比大小，相当单机版本（没有房间的概念）

 ..* test/client.py 模拟客户端发起交易
 ..* test/server.py 模拟服务端监听开牌结果
