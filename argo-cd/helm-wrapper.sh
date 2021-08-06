#! /bin/sh

GPG_KEY='/home/argocd/gpg/gpg.asc'

if [ -f ${GPG_KEY} ]
then     
    gpg --quiet --import ${GPG_KEY}
    gpg --export-secret-keys > ~/.gnupg/secring.gpg
fi

if [ $1 = "template" ] || [ $1 = "install" ] || [ $1 = "upgrade" ] || [ $1 = "lint" ] || [ $1 = "diff" ]
then 
    out=$(helm.bin secrets $@)
    code=$?
    if [ $code -eq 0 ]; then
        # printf insted of echo here because we really don't want any backslash character processing
        printf '%s\n' "$out" | sed -E "/^removed '.+\.dec'$/d"      
        exit 0
    else
        exit $code
    fi
else
    # helm.bin is the original helm binary
    exec helm.bin $@
fi
