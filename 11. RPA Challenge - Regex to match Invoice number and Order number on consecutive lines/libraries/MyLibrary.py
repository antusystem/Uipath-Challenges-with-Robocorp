from robot.api import logger
import re


class MyLibrary:
    """This class conatins the metod to do a regex search

    Methods
    -------

    re_search: Method that do a regex search in the text provided

    """

    def re_search(self, regex, text):
        """Method that do a regex search in the text provided.

        Parameters
        ----------
        regex : str
            Regular Expression that will be use to search.

        text : str
            String that will be searched.

        Return
        ----------
        result : list
            List that contains the matches found in the search.
            All matches are in the first element of the list.
            It's a list of list.
        """
        # logger.info("The regex is: " + regex,
        #            also_console=True)
        # logger.info("The text is: " + text,
        #            also_console=True)
        result = re.findall(regex, text)
        # logger.info("The element(s) found is/are: " + str(x),
        #            also_console=True)
        return result
