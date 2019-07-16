#coding:utf8
from selenium import webdriver
import time , requests
from lxml import etree
from pyquery import PyQuery as pq
import re


opt = webdriver.ChromeOptions()
prefs = {'profile.default_content_setting_values': {'images': 2}}
opt.add_experimental_option('prefs', prefs)
opt.add_argument('Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36 MicroMessenger/6.5.2.501 NetType/WIFI WindowsWechat QBCore/3.43.884.400 QQBrowser/9.0.2524.400')
driver = webdriver.Chrome(options=opt)

def save_source(url,count):
    print(url)
    driver.get(url)
    f = open(r'./source_page/' + str(count) + '.html','w',encoding='utf-8')
    f.write(driver.page_source)
    f.close()

count = 1
for i in open('./aother.txt'):
    url = i.strip()
    count += 1
    save_source(url,count)
