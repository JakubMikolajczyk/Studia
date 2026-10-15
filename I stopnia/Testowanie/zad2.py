import os
import time
import urllib.request

from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import Select

chrome_options = Options()
chrome_options.add_argument("--headless")
driver = webdriver.Chrome(options=chrome_options)  # Optional argument, if not specified will search path.
driver.get('file:///Users/jakubmikolajczyk/PycharmProjects/Testowanie/page/index.html')
link = driver.find_element(By.LINK_TEXT, "Gallery")
link.click()

wrap = driver.find_element(By.CLASS_NAME, 'wrapper')
images = wrap.find_elements(By.TAG_NAME, "img")

os.mkdir('downloaded_images')

for img in images:
    src = img.get_attribute('src')
    print(src.split('/')[-1])
    urllib.request.urlretrieve(src, 'downloaded_images/' + src.split('/')[-1])


