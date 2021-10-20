from robot.api import logger


class MyLibrary:
    """Give this library a proper name and document it."""

    def example_python_keyword(self):
        logger.info("This is Python!")

    def tipo(self, var):
        logger.info("The variable: " + str(var), also_console=True)
        logger.info("The type of it is: " + str(type(var)), also_console=True)
