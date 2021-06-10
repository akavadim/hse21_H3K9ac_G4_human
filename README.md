# hse21_H3K9ac_G4_human Отчет
### Студент: Максимов Вадим Александрович

|Организм    |DNA_structure|histone_mark|Тип клеток|.bed файл 1  |.bed файл 2  |
|------------|-------------|------------|----------|-------------|-------------|
|human (hg19)|[G4_seq_Li_K]|H3K9ac      |K562      |[ENCFF568DJI]|[ENCFF280OVN]|

## Анализ пиков гистоновой метки
Были скачаны 2 файла и помещены в папку Data ([ENCFF568DJI] и [ENCFF280OVN]) 

При распаковке оставлены только 5 столбцов:
```
cat ENCFF568DJI.bed | cut -f1-5 > H3K9ac_K562_ENCFF568DJI_hg38.bed
cat ENCFF280OVN.bed | cut -f1-5 > H3K9ac_K562_ENCFF280OVN_hg38.bed
```

Приведение координат ChIP-seq пиков к нужной версии генома `hg19`:
```
wget https://hgdownload.cse.ucsc.edu/goldenpath/hg38/liftOver/hg38ToHg19.over.chain.gz
liftOver   H3K9ac_K562_ENCFF280OVN_hg38.bed   hg38ToHg19.over.chain.gz   H3K9ac_K562_ENCFF280OVN_hg19.bed   H3K9ac_K562_ENCFF280OVN_unmapped.bed
liftOver   H3K9ac_K562_ENCFF568DJI_hg38.bed   hg38ToHg19.over.chain.gz   H3K9ac_K562_ENCFF568DJI_hg19.bed   H3K9ac_K562_ENCFF568DJI_unmapped.bed
```

Гистограммы длин участков для каждого эксперимента до и после конвертации к нужной версии генома ([Скрипт](https://github.com/vadim299/hse21_H3K9ac_G4_human/blob/main/src/len_hist.R)) 
<p float="left">
  <img width="45%" src="https://github.com/vadim299/hse21_H3K9ac_G4_human/blob/main/images/len_hist.H3K9ac_K562_ENCFF280OVN_hg38.png" />
  <img width="45%" src="https://github.com/vadim299/hse21_H3K9ac_G4_human/blob/main/images/len_hist.H3K9ac_K562_ENCFF280OVN_hg19.png" />
</p>
<p float="left">
  <img width="45%" src="https://github.com/vadim299/hse21_H3K9ac_G4_human/blob/main/images/len_hist.H3K9ac_K562_ENCFF568DJI_hg38.png" />
  <img width="45%" src="https://github.com/vadim299/hse21_H3K9ac_G4_human/blob/main/images/len_hist.H3K9ac_K562_ENCFF568DJI_hg19.png" />
</p>

Фильтрация пик (<4000) ([Скрипт](https://github.com/vadim299/hse21_H3K9ac_G4_human/blob/main/src/filter_peaks.R))
<p float="left">
  <img width="45%" src="https://github.com/vadim299/hse21_H3K9ac_G4_human/blob/main/images/filter_peaks.H3K9ac_K562_ENCFF280OVN_hg19.filtered.hist.png" />
  <img width="45%" src="https://github.com/vadim299/hse21_H3K9ac_G4_human/blob/main/images/filter_peaks.H3K9ac_K562_ENCFF568DJI_hg19.filtered.hist.png" />
</p>

Для постройки пай-чартов используется [данный скрипт](https://github.com/vadim299/hse21_H3K9ac_G4_human/blob/main/src/chip_seeker.R)

Пай-чарт для [ENCFF568DJI]

![a](https://github.com/vadim299/hse21_H3K9ac_G4_human/blob/main/images/chip_seeker.H3K9ac_K562_ENCFF280OVN_hg19.filtered.plotAnnoPie.png)

Пай-чарт для [ENCFF568DJI]

![a](https://github.com/vadim299/hse21_H3K9ac_G4_human/blob/main/images/chip_seeker.H3K9ac_K562_ENCFF568DJI_hg19.filtered.plotAnnoPie.png)

Объединяем отфильтрованные данные:
```
cat  *.filtered.bed  |   sort -k1,1 -k2,2n   |   bedtools merge | cut -f1-3 >  H3K9ac_K562.merge.hg19.bed 
```

## Анализ участков вторичной стр-ры ДНК
Помещаем [два файла][G4_seq_Li_K] со вторичной структурой ДНК в папку Data
Объединяем эти файлы:
```
cat  G4_seq_Li_K_1.bed G4_seq_Li_K_2.bed  |   sort -k1,1 -k2,2n   |   bedtools merge  >  G4_seq_Li_K.merge.bed 
```
Строим гистограмму распределения длин и пай-чарт:
<p float="left">
  <img width="45%" src="https://github.com/vadim299/hse21_H3K9ac_G4_human/blob/main/images/len_hist.G4_seq_Li_K.merge.png" />
  <img width="45%" src="https://github.com/vadim299/hse21_H3K9ac_G4_human/blob/main/images/chip_seeker.G4_seq_Li_K.merge.plotAnnoPie.png" />
</p>

Находиме пересечения гистоновой меткой и стр-рами ДНК:
```
bedtools intersect  -a G4_seq_Li_K.merge.bed    -b  H3K9ac_K562.merge.hg19.bed   >  H3K9ac_K562.intersect_with_G4.bed
```
Распределение длин для пересечения гистоновой метки и стр-рами ДНК:
![a](https://github.com/vadim299/hse21_H3K9ac_G4_human/blob/main/images/len_hist.H3K9ac_K562.intersect_with_G4.png)

Загружаем все в геномный браузер:
```
track visibility=dense name="ENCFF280OVN"  description="H3K9ac_K562_ENCFF280OVN_hg19.filtered.bed"
https://github.com/vadim299/hse21_H3K9ac_G4_human/blob/main/Data/H3K9ac_K562_ENCFF280OVN_hg19.filtered.bed?raw=true

track visibility=dense name="ENCFF568DJI"  description="H3K9ac_K562_ENCFF568DJI_hg19.filtered.bed"
https://github.com/vadim299/hse21_H3K9ac_G4_human/blob/main/Data/H3K9ac_K562_ENCFF568DJI_hg19.filtered.bed?raw=true

track visibility=dense name="ChIP_merge"  color=50,50,200   description="H3K9ac_K562.merge.hg19.bed"
https://github.com/vadim299/hse21_H3K9ac_G4_human/blob/main/Data/H3K9ac_K562.merge.hg19.bed?raw=true

track visibility=dense name="G4_seq_Li_K"  color=0,200,0  description="G4_seq_Li_K.merge.bed"
https://github.com/vadim299/hse21_H3K9ac_G4_human/blob/main/Data/H3K9ac_K562.intersect_with_G4.bed?raw=true

track visibility=dense name="intersect_with_G4_seq_Li_K"  color=200,0,0  description="H3K9ac_K562.intersect_with_G4.bed"
https://github.com/vadim299/hse21_H3K9ac_G4_human/blob/main/Data/G4_seq_Li_K.merge.bed?raw=true
```
Место пересечение между гистоновой меткой и стр-рой ДНК. (Координаты: chr3:12,329,573-12,329,883. [Сохраненная сессия](https://github.com/vadim299/hse21_H3K9ac_G4_human/blob/main/session))
![a](https://github.com/vadim299/hse21_H3K9ac_G4_human/blob/main/images/genome.ucsc.screen.png)

Ассоциируем полученные пересечения с ближайшими генами ([Скрипт](https://github.com/vadim299/hse21_H3K9ac_G4_human/blob/main/src/ChIPpeakAnno.R))
[14734 пиков](https://github.com/vadim299/hse21_H3K9ac_G4_human/blob/main/Data/H3K9ac_K562.intersect_with_DeepZ.genes.txt) из них [9005 уникальных](https://github.com/vadim299/hse21_H3K9ac_G4_human/blob/main/Data/H3K9ac_K562.intersect_with_DeepZ.genes_uniq.txt).

Go-анализ
![a](https://github.com/vadim299/hse21_H3K9ac_G4_human/blob/main/images/go-analysis.png)
Наиболее значимые: 
![a](https://github.com/vadim299/hse21_H3K9ac_G4_human/blob/main/images/go-analysis_1.png)

[ENCFF280OVN]: https://www.encodeproject.org/files/ENCFF280OVN/
[ENCFF568DJI]: https://www.encodeproject.org/files/ENCFF568DJI/
[G4_seq_Li_K]:https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSM3003539
