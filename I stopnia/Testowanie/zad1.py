import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import Select

driver = webdriver.Chrome('./chromedriver')  # Optional argument, if not specified will search path.
driver.get('file:///Users/jakubmikolajczyk/PycharmProjects/Testowanie/page/index.html')
# time.sleep(1)

link = driver.find_element(By.LINK_TEXT, "Contact")
link.click()
# time.sleep(1)

form = driver.find_element(By.ID, "contact_form")
inputs = form.find_elements(By.XPATH, "*")
all_empty = True
for input in inputs:
    if input.get_attribute("type") == 'text' or input.get_attribute("type") == 'textarea':
        assert input.get_attribute("value") == ""

    if input.get_attribute("type") == 'select-one':
        assert input.get_attribute("selectedIndex") == '0'

for input in inputs:
    if input.get_attribute("type") == 'text' or input.get_attribute("type") == 'textarea':
        input.send_keys("Test")

    if input.get_attribute("type") == 'select-one':
        select = Select(input)
        select.select_by_index(2)

driver.save_screenshot("zad1.png")

submit = form.find_element(By.XPATH, "//input[@type='submit']")
submit.click()
time.sleep(5)
driver.switch_to.alert.accept()
time.sleep(5)
driver.quit()
