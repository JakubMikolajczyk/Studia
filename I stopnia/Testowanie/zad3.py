import re
import time

from selenium import webdriver
from selenium.webdriver import Keys
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.common.action_chains import ActionChains

chrome_options = Options()
# chrome_options.add_argument("--headless")
driver = webdriver.Chrome(options=chrome_options)  # Optional argument, if not specified will search path.
driver.get('https://en.wikipedia.org/')

search = driver.find_element(By.ID, 'searchInput')
search.send_keys('Python')
searchButton = driver.find_element(By.ID, 'searchButton')
searchButton.click()

searchOutput = driver.find_element(By.ID, 'mw-content-text')

links = searchOutput.find_elements(By.TAG_NAME, 'a')
links = filter(lambda link: re.search('python', link.text, re.IGNORECASE), links)
windowBefore = driver.current_window_handle
for link in links:
    # time.sleep(1)
    # link.click()
    action = ActionChains(driver)
    action.key_down(Keys.SHIFT)\
        .click(link)\
        .key_up(Keys.SHIFT).perform()
    windowAfter = driver.window_handles[-1]
    driver.switch_to.window(windowAfter)
    print(driver.title)
    p = driver.find_elements(By.TAG_NAME, 'p')
    for text in p:
        if text.text != '':
            print(text.text)
            break
    print()
    print()
    driver.close()
    driver.switch_to.window(windowBefore)

driver.quit()
