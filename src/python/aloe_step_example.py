# -----------------------------------------------------------------------------
# Aloe testing step requested by Lee Render, lead software engineer at the
# Centre of Comparative Genomics, for the Rare Disease Registry Framework
# -----------------------------------------------------------------------------
# - In addition to a large number of prior steps, imports, etc.
# - Relies on Aloe imports step and world.
# - Does not rely on any other steps or functions.
# - To use in "standard" Selenium, replace world.browser with webdriver name
# - Written at work for automated testing of the RDRF.
# -----------------------------------------------------------------------------
# The task was to produce a new function given an Aloe step for the purpose of
# a baseline setup for future steps -- that is, a known set of patients could
# be prepared prior to running through a series of scenarios within a feature.
# -----------------------------------------------------------------------------


@step('I add patient name "(.*)" sex "(.*)" birthdate "(.*)"')
def add_new_patient(step, name, sex, birthdate):

    # Imports:

    import time

    # Define helper functions:

    def find(xp):
        element = world.browser.find_element_by_xpath(xp)
        return(element)

    def scroll_to_centre(xp):
        y = find(xp).location["y"]
        off = world.browser.get_window_size()["height"]
        move = y - (1 / 2) * off
        world.browser.execute_script("scrollTo(0, %s)" % move)

    # Extract the user's names:
    surname, firstname = name.split()
    # Go to the patients listing:
    world.browser.get(
        find("//a[text()='Patient List']").get_attribute("href")
    )
    # Go to the add patient page:
    find("//button[@id='add_patient']").click()
    # Select registry and working group centre:
    find("//option[contains(., 'REGISTRY_NAME')]").click()  # Reg. name masked
    find("//option[contains(., 'CENTRE_NAME')]").click()  # Centre name masked
    # Enter minimal required patient data:
    find("//input[@name='family_name']").send_keys(surname)
    find("//input[@name='given_names']").send_keys(firstname)
    find("//input[@name='date_of_birth']").send_keys(birthdate, Keys.ESCAPE)
    # Required for date widget to fade to avoid intercepting clicks:
    time.sleep(0.15)
    # Avoid page banners:
    scroll_to_centre("//select[@name='sex']")
    find("//select[@name='sex']").click()
    find("//select[@name='sex']/option[text()='%s']" % sex).click()
    # Submit:
    find("//button[@id='submit-btn']").click()
    # Check for the success message:
    assert "Patient added successfully" in world.browser.page_source,\
        "Patient add success message not present"
