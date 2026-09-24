# terraform-venv
(c) 2021-2022 NetTempo, Inc.  
MIT License  
see [LICENSE](LICENSE) for details

Creates a virtual terraform environment in your current directory, which allows you to run a specific version of terraform
(or [OpenTofu](https://opentofu.org)) for a project.

## Instructions
### Installation
From a clone of this repo, on Linux or macOS:
```bash
./install.sh            # installs into /usr/local/bin (uses sudo if needed)
./install.sh --user     # installs into ~/.local/bin, no sudo
./install.sh --dir DIR  # installs into DIR
```
This installs `terraform-venv` and `opentofu-venv` (a symlink to it). Re-run it after pulling to update.
Add `--uninstall` (with the same `--user`/`--dir` option) to remove them.

To install by hand instead, copy `terraform-venv` into a directory in your `PATH`, run `chmod +x terraform-venv`, and
optionally `ln -s terraform-venv opentofu-venv` in that directory.

### Setting up
1. Run: `terraform-venv <version>`
2. Source: `source tf-venv/tf-activate`
3. Verify: `terraform version`

### Deactivating
1. Run: `tf-deactivate`
2. Verify: `terraform version`

### Cleanup
* Run: `rm -rf tf-venv`

### Example:
```bash
$ pwd
/home/mydir/gitdir/my-great-terraform-project

$ terraform version
Terraform v0.12.29

Your version of Terraform is out of date! The latest version
is 0.15.3. You can update by downloading from https://www.terraform.io/downloads.html

$ terraform-venv 0.14
terraform_0.14.11_linux_amd64.zip: OK
Archive:  terraform_0.14.11_linux_amd64.zip
  inflating: terraform               
  
$ source tf-venv/tf-activate 

(TF 0.14.11) $ terraform version
Terraform v0.14.11

Your version of Terraform is out of date! The latest version
is 0.15.3. You can update by downloading from https://www.terraform.io/downloads.html

(TF 0.14.11) $ tf-deactivate 

$ terraform version
Terraform v0.12.29

Your version of Terraform is out of date! The latest version
is 0.15.3. You can update by downloading from https://www.terraform.io/downloads.html

$ rm -rf tf-venv/

$ terraform-venv 
terraform_0.15.3_linux_amd64.zip: OK
Archive:  terraform_0.15.3_linux_amd64.zip
  inflating: terraform               
  
$ source tf-venv/tf-activate 

(TF 0.15.3) $ terraform version
Terraform v0.15.3
on linux_amd64

(TF 0.15.3) $ tf-deactivate 

$ terraform version
Terraform v0.12.29

Your version of Terraform is out of date! The latest version
is 0.15.3. You can update by downloading from https://www.terraform.io/downloads.html

$ rm -rf tf-venv/

```


## OpenTofu
To use OpenTofu instead of Terraform, run either of:
* `terraform-venv --opentofu [<version>]` (or `-o`)
* `opentofu-venv [<version>]`

The `tofu` binary is installed in `tf-venv`, together with a `terraform` symlink to it. That means both `tofu` and
`terraform` run OpenTofu while the venv is active (in scripts and Makefiles too). Activating and deactivating work
exactly as they do for Terraform (`source tf-venv/tf-activate` / `tf-deactivate`). The prompt shows `(TOFU <version>)`.

```bash
$ opentofu-venv 1.11
tofu_1.11.14_linux_amd64.zip: OK

$ source tf-venv/tf-activate

(TOFU 1.11.14) $ terraform version
OpenTofu v1.11.14
on linux_amd64
```

OpenTofu releases come from GitHub, and the version list comes from `https://get.opentofu.org/tofu/api.json`.

## Version info
* Only stable releases are selected; alpha, beta, and rc releases are skipped (for both Terraform and OpenTofu).
* If no version is provided, then the most recent version of terraform will be used.
* If only a major version number is provided, e.g. `terraform-venv 1`, then the most recent version in that major release will be used.
* If a major.minor version number is provided, e.g. `terraform-venv 0.12`, then that specific version will be used.
* If a major.minor.release version number is provided, e.g. `terraform-venv 0.12.31`, then that specific release will be used.