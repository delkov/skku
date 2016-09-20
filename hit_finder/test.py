from astropy.io import fits 
# import numpy as np
# import matplotlib
# Set up matplotlib and use a nicer set of plot parameters
# config InlineBackend.rc = {}
# import matplotlib
# matplotlib.rc_file("../../templates/matplotlibrc")
# import matplotlib.pyplot as plt
# matplotlib inline
image_file='1bits.fits'
# hdulist = pyfits.open(filename)

# print(hdulcdist.info())
# hdu = hdulist[0]
# print(hdu.data)
# image_data = fits.getdata(image_file)


f = fits.open('test1.fits')
data=f[0].data
print(data.shape[1])

print(data)
# print(data[0,1])
# assume the first extension is an image


# header['OBJECT']="M31"
# print(data, '\n')
# print(scidata)

# fits.writeto('output_file.fits', data, header, clobber=True)

# import matplotlib.pyplot as plt
# plt.plot([1,2,3,4,5])
# plt.show()




# # import numpy as np
# # import matplotlib.pyplot as plt
# # from astropy.modeling import models, fitting

# # # Generate fake data
# # np.random.seed(0)
# # x = np.linspace(-5., 5., 200)
# # y = 3 * np.exp(-0.5 * (x - 1.3)**2 / 0.8**2)
# # y += np.random.normal(0., 0.2, x.shape)

# # # Fit the data using a box model
# # t_init = models.Trapezoid1D(amplitude=1., x_0=0., width=1., slope=0.5)
# # fit_t = fitting.LevMarLSQFitter()
# # t = fit_t(t_init, x, y)

# # # Fit the data using a Gaussian
# # g_init = models.Gaussian1D(amplitude=1., mean=0, stddev=1.)
# # fit_g = fitting.LevMarLSQFitter()
# # g = fit_g(g_init, x, y)

# # # Plot the data with the best-fit model
# # plt.figure(figsize=(8,5))
# # plt.plot(x, y, 'ko')
# # plt.plot(x, t(x), label='Trapezoid')
# # plt.plot(x, g(x), label='Gaussian')
# # plt.xlabel('Position')
# # plt.ylabel('Flux')
# # plt.legend(loc=2)


# import numpy as np
# Z = np.ones(
# print(Z[1,1])
