file=$1
langPath="./lang/$file.md"

if [ ! -f "$langPath" ]
then
    echo "$langPath file does not exists"
    exit 1
fi

echo "Making summary of $langPath"


grep -o -E "^#.+" "$langPath" |
while IFS= read -r title
do

    slug=$(echo $title | sed -e 's/\#\{1,\} //g' | sed -e 's/\(.*\)/\L\1/' | sed 's/[^a-z]/\-/g')
    menu=$(echo $title | sed -e 's/#//g' | sed -e 's/^ //g' )
    nest=$(echo $title | sed -e 's/^#//' | sed -e 's/[^#]//g' | sed -e 's/#/  /g' )

    #echo $title
    #echo "slug [$slug]"
    #echo "menu [$menu]"
    #echo "nest [$nest]"
    echo "$nest- [$menu](#$slug)"
done