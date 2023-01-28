def process_hmm_annotations(df):
    df=pd.read_csv(df,sep=' ')
    df = df.iloc[1: , :]
    transcript_dict={}
    for scaffold, group in df.groupby('#'):
        group['subdomain']=group['Generated'].str.split('_clustalo',expand=True)[0]
        group['start']=(group['one'].str.split('-',expand=True)[0]).astype(int)

        size=scaffold.split('size')[1]



        if int(size) > 1500:
            count=(len(re.findall(r'CIDRa',','.join(list(group['subdomain'])))))
            if count >1:



                subset_CIDRa=group[group['Generated'].str.contains('CIDRa')==True]
                subset_CIDRa['of']=subset_CIDRa['of'].astype(float)

                only_CIDRa=subset_CIDRa[subset_CIDRa['of']==subset_CIDRa['of'].min()].head(1)
                group=group[group['Generated'].str.contains('CIDRa')==False]
                group=group.append(only_CIDRa)
                group=group.sort_values(by='start')
            count=(len(re.findall(r'DBLa',','.join(list(group['subdomain'])))))
            if count >1:

                    subset_DBLa=group[group['Generated'].str.contains('DBLa')==True]
                    subset_DBLa['of']=subset_DBLa['of'].astype(float)
                    only_DBLa=subset_DBLa[subset_DBLa['of']==subset_DBLa['of'].min()].head(1)
                    group=group[group['Generated'].str.contains('DBLa')==False]
                    group=group.append(only_DBLa)

                    group=group.sort_values(by='start')

            transcript=list(group['subdomain'])
            if len(set(transcript))==1:
                transcript=set(transcript)

            transcript='-'.join(transcript)
            if len(transcript)>=3:





                transcript_dict[scaffold]=transcript

    return transcript_dict
