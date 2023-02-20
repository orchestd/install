## GitHub

If your git cli is not configured to use github, please complete the following:

1. Configue git user email on your computer, [follow the process in this link](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-email-preferences/setting-your-commit-email-address#setting-your-email-address-for-every-repository-on-your-computer)
2. Sign in to your [github](https://github.com/) account
3. Create a **public** github repo named "**apispecs**", make sure you check "Add a README file". [this link will take you there](https://github.com/new?repo_name=apispecs)

Enable github access using ssh key, [follow the process in this link](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) or follow these steps:
1. Create an ssh key using your github account email by typing the following command, and hit "return" with no more details until the process ends:
    ```
    $ ssh-keygen -t ed25519 -C "your_github_account_email@somewhere.com"
    ```
2. Activate ssh agent and register the newly generated private key
    ```
    $ eval $(ssh-agent -s)
    $ ssh-add ~/.ssh/id_ed25519
    ```
3. Echo to console the generated public key
    ```
    $ cat ~/.ssh/id_ed25519.pub
    ```
4. Use the public key to create "New SSH Key" in your github account here: 
    [https://github.com/settings/ssh/new](https://github.com/settings/ssh/new)
<br /><br />
