#! /bin/bash

if [ -d "gif" -o -d "swf" ]; then
	read -p "re wget? [Y/n]" ch
	if [ "$(echo $ch | tr '[a-z]' '[A-Z]' | cut -c 1)" == "Y" ]; then
		rm -rf "gif" "swf" "html" "word.txt"
	else
		exit
	fi
fi

if [ ! -d "html" ]; then
	mkdir "html"
fi

while read line; do
	# 注意：负数的偏移量与冒号之间至少有一个空格，这样可以避免与 :- 扩展相混淆
	if [ "${line: -1}" == "画" ]; then
		continue
	fi

	for word in $line; do
		# -q 只输出MD5值
		# -s 指定字符串计算
		md=`md5 -q -s "$word"`

		# -q 安静模式
		# -P 指定下载目录
		wget -q -P "./gif/" "http://www.52wubi.com/wbbmcx/tp/$word.gif"
		wget -q -P "./swf/" "http://hanyu.iciba.com/bihuaswf/$md.swf"

		# 重命名
		mv "./gif/$word.gif" "./gif/$md.gif"

		# 文本替换
		#sed "s/replace/$md/g" "index.html" > "html/$md.html"

		# 写入文件
		echo \"$word\", >> word.txt
	done

	#break
done < hanzi.txt
# 奇怪的现象：cat file | while read line; do; done，这种方式计数递增失效

# 可以通过以下命令查看获取文件数量
# ls -l | grep "^-" | wc -l
