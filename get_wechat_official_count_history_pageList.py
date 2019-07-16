from selenium import webdriver
import time , requests
from lxml import etree
from pyquery import PyQuery as pq
import re



url = "https://mp.weixin.qq.com/mp/getmasssendmsg?__biz=MzAxNDEyMTg4Ng==&uin=MjEzNTY2NjcyMA%3D%3D&key=3d08f3c064ad21db0dc041d1d0d0e7a3444800b52778aeeb9179952c4a5295fbd96400b22a75b717e8353b491265897362c45d7ef52ee399929d0af163934a3ba9f274d74b882a68adb8ee723ee08af8&devicetype=Windows+10&version=62060833&lang=zh_CN&ascene=7&pass_ticket=%2B1F5dMYgXZlUUyf5H6yi36I1dF4jtGmuDbNXEDLVS%2BWYqoPE7a3eCGe%2BsV7Spug%2F"

# Chromedriver
opt = webdriver.ChromeOptions()
# prefs = {'profile.default_content_setting_values': {'images': 2}}
# opt.add_experimental_option('prefs', prefs)#这两行是关闭图片加载
opt.add_argument('Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36 MicroMessenger/6.5.2.501 NetType/WIFI WindowsWechat QBCore/3.43.884.400 QQBrowser/9.0.2524.400')#设置headers
# # opt.add_argument('--headless')#此行打开无界面
driver = webdriver.Chrome(options=opt)

driver.get(url)

top = 1
while 1:
    html = etree.HTML(driver.page_source)
    downss = html.xpath('//*[@id="js_nomore"]/div/span[1]/@style')
    if downss[0] == "display: none;":
        time.sleep(0.5)
        js = "var q=document.documentElement.scrollTop="+str(top*2000)
        driver.execute_script(js)#模拟下滑操作
        top += 1
        time.sleep(1)
    else:
        break
html = etree.HTML(driver.page_source)
bodyContent = html.xpath('//*[@id="js_history_list"]/div/div/div/div/h4/@hrefs')#获取文章的所有链接

#保存本地
fp = open("./aother.txt", "w+")
for i in bodyContent:
    fp.write(str(i) + "\n")
driver.close()
fp.close()
