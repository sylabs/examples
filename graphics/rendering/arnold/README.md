Arnold is a Monte Carlo ray tracing renderer.

  https://www.solidangle.com/arnold/

Arnold must be installed interactive. So, the Definition file provided will
give you the base OS. The full steps to install Arnold into the container
are provided at:

  https://www.sylabs.io/2018/09/containerizing-arnold-renderer

A quick run through is:

  1) Download Arnold, and copy to /tmp
  2) Build a sandbox image with provided Definition file
  3) Install Arnold into writable sandbox (/opt/arnold install location)


