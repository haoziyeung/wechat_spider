# 抓取某微信公众号所有历史文章列表及其内容

## requirements
* windows系统
* Fidder抓包软件
* python3（推荐Miniconda3）
* chrome浏览器及对应版本的chromedriver
* python modules：selenium（自动化测试）、lxml、pyquery

## 操作步骤
1. 启动抓包软件Fidder
1. 登录PC版微信，点击目标公众号右上角的“查看历史消息”按钮，去抓包软件里面找到一个/mp/getmasssendmsg的请求，拷贝该URL（包括GET参数哦）。
1. 将get_wechat_official_count_history_pageList.py脚本里面的url变量替换成你刚拷贝下来的URL（该URL过太久了会失效的，所以注意步骤2和步骤3的间隔）
1. python get_wechat_official_count_history_pageList.py #这一步的原理是模拟鼠标下滑操作，获取历史文章列表
1.  python download_history_pageContent.py #这一步的原理是模拟浏览器访问每一个历史文章，并保存HTML源码
1. `perl html.parser.pl |grep -v "===========" | sed 's#;line-height:normal;">##g' > test.txt`   #这一步的原理是解析HTML源码，把我想要的内容搞出来，so，你不必用这一个脚本，你应该自己写一个类似的脚本

参考：https://www.cnblogs.com/dahuag/p/9284677.html
