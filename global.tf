
locals {
  vpc = {
      dev = "vpc-afcf22d7"
      prod = "vpc-0d7b607beb7b4ae3c"
  }

  az = {
      dev = ["us-west-2b", "us-west-2c"]
      prod = ["us-west-2a", "us-west-2d"]
  }

  subnet = {
      dev = [
        "subnet-0d35c4ca7a3336d2a", #us-west-2a
        "subnet-0bdf73792e8aa50ed", #us-west-2b
        "subnet-08a9184d437097d71", #us-west-2c
        "subnet-0d003749e682fedd4", #us-west-2d
      ]
      prod = [
        "subnet-0d35c4ca7a3336d2a", #us-west-2a
        "subnet-0bdf73792e8aa50ed", #us-west-2b
        "subnet-08a9184d437097d71", #us-west-2c
        "subnet-0d003749e682fedd4", #us-west-2d 
      ]

  }

  key = {}

}

