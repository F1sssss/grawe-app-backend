select
    gd.*
from gr_dnevne_greske gd(nolock)
left join gr_error_exceptions gi (nolock) on gi.polisa=gd.polisa and gi.id_greske=gd.id_greske
where
gi.polisa is null
and convert(varchar,gd.datum_greske,102)=@date
