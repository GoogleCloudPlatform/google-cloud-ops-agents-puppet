image_family=$1

cat <<END>packer.json
      {
      "builders": [
        {
          "image_name": "$(echo ${image_family}-$(git rev-parse --short HEAD))",
          "image_family": "puppet-${image_family}",
          "source_image_family": "${image_family}",
          "type": "googlecompute",
          "project_id": "united-aura-313415",
          "ssh_username": "packer",
          "zone": "us-east1-b",
          "startup_script_file": "bootstrap.sh",
          "scopes": [
            "https://www.googleapis.com/auth/userinfo.email",
            "https://www.googleapis.com/auth/compute",
            "https://www.googleapis.com/auth/devstorage.full_control"
          ]
        }
        ]
      }
END

packer build packer.json

rm -f packer.json