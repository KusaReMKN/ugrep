#! /bin/sh

# 失敗したら死ぬ
set -e

# uconv がインストールされているか調べる
if ! which 'uconv' >/dev/null
then
  echo "uconv: not found" >/dev/stderr
  exit 1
fi

# grep がインストールされているか調べる
if ! which 'grep' >/dev/null
then
  echo "grep: not found" >/dev/stderr
  exit 1
fi

# grep 用のオプションを得る
gopts=""
nform="nfc"
while getopts :EFX:ce:f:ilnqsvx OPT
do
  case $OPT in
    ([EFcilnqsvx])
      gopts="$gopts-$OPT "
      ;;
    (e)
      nopattern=1
      gopts="$gopt-$OPT \"$(printf %s "$OPTARG" | uconv -x "$nform")\" "
      ;;
    (f)
      nopattern=1
      gopts="$gopts-$OPT \"$OPTARG\" "
      ;;
    (X)
      nform="$OPTARG"
      ;;
    (:)
      echo "Missing argument for -X, -e or -f option" >/dev/stderr
      exit 1
      ;;
    (*)
      break
      ;;
  esac
done
shift $((OPTIND - 1))

# grep のパターン引数が必須であればパターンを憶える
if [ -z "$nopattern" ]
then
  pattern="$(printf %s "$1" | uconv -x "$nform")"
  shift
fi

# これが本体
uconv -x "$nform" "$@" | grep $gopts "$pattern"

# ex: se ts=2 et :
