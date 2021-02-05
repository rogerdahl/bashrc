# find /usr -daystart -newermm /var/log/installer -printf %TY-%Tm-%Td %pn | sort | uniq -c | sort -k2

# https://www.computerhope.com/unix/bash/read.htm

while IFS= read -r -d $'\n' pkg; do
	[[ -n "$(apt version "$pkg")" ]] && {

		printf "%s\n" "$(apt version "$pkg")"
	}
	#  printf "FILE: %s\n" "$f";
	#  printf "%s\n" "$(apt version "$pkg")"
done < <(perl -pe 's/\/.*//' <(apt list))

#
#
#perl -pe 's/\/.*//'
#
#while IFS= read -r -d $'\0' f
#do
#  printf "FILE: %s\n" "$f";
#  printf "%s\n" "$(apt contains "$f")"
#
#done < <(find /usr -type f -newermm /var/log/installer -printf "%p\0")
#
#
#
##while IFS= read -r -d $'\0' f
##do
##  printf "FILE: %s\n" "$f";
##  printf "%s\n" "$(apt contains "$f")"
##
##done < <(find /usr -type f -newermm /var/log/installer -printf "%p\0")
#
#
