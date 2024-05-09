FROM python:bullseye as python


# Stage: itksnap (built with Ubuntu16.04 - glibc 2.23)
FROM khanlab/itksnap:main as itksnap
RUN cp -R /opt/itksnap/ /opt/itksnap-mini/ \
    && cd /opt/itksnap-mini/bin \
    && rm c2d itksnap* 

FROM python as runtime
COPY --from=itksnap /opt/itksnap-mini/* /opt/bin


#install pythondeps (including ome-zarr separately, having issues with including it in pyproject - also use master branch
#to get latest fixes for omero metadata)
COPY . /opt/pythondeps
RUN pip install --no-cache-dir /opt/pythondeps


ENTRYPOINT ["/bin/bash"]
