# 并发模型
## actor模型
erlang actor之间直接通讯，注重处理单元

## csp
csp解耦发送方和接受方，注重消息传递方式，数据结构是队列

## channel的实现原理与特性
(Channel 源码)[https://github.com/golang/go/blob/master/src/runtime/chan.go]
channel结构有mutex是线程安全的
channel.buf是一个环形队列

## channel实践应用
- 定时任务
- 控制协程数量
- 跟空struct结合使用，控制任务状态 (io.PIPE)

# golang并发安全
- load -> update -> save
- Data-race
## 悲观锁
- 每次拿数据都认为别人会修改数据
- 数据库行锁，表锁
## 乐观数
- 每次拿数据都认为别人不会修改，更新中确认是否修改
- 适用场景：多读
- CAS操作，write_condition
## 自旋锁
尝试获取，不会立即阻塞
- 特点： 减少CPU上下文切换，但是消耗cpu

# golang对线程安全的支持
- Channel
- Sync
1.原子操作 （Atomic）
2.锁 （Lock）
3.信号量 （Cond）

# golang中的锁
` Mutex
- RwMutex - Mutex + readerCouter

# 死锁 活锁 饥饿
- 资源被多个协程占用，全部等待，无法进行任务
- 多个协程占用部分资源，释放重新获取子u按，依旧碰撞，任务无法执行
- 循环等待，无法执行

# 死锁解决方案
- 不用锁
- 原子操作

# 锁的经验
- 不要嵌套使用锁
- 锁是同类型成对出现的
- 减少锁定粒度，尽早释放
- 尽量不要向原子值中存储未用类型的指，会有线程安全问题

# 如何排查死锁和数据竞争
- go build -race
- 通过pprof分析sync.runtime_SemacquireMutex
- 第三方工具
- 分析代码

# wsl host
```bash
ip route | grep src | awk '{print $9}'
```