from robot.api import logger
import matplotlib.pyplot as plt


class PlotingLibrary:
    """This Library pliots the data acording to the labels and sizes

    Methods
    -------

    plotting: plots the data in labels and sizes.

    """

    def plotting(self, labels, sizes):
        """ Plots the data in labels and sizes.

        Parameters
        ----------
        labels : list
            List with the labels.

        sizes : list
            List with the sizes.

        """
        # Only "explode" the 2nd slice
        explode = (0, 0.1, 0, 0, 0, 0, 0, 0, 0, 0, 0)
        fig1, ax1 = plt.subplots()
        ax1.pie(sizes, explode=explode, labels=labels, autopct='%1.1f%%',
                shadow=True, startangle=90)
        # Equal aspect ratio ensures that pie is drawn as a circle.
        ax1.axis('equal')
        plt.show()


