use strict;
use warnings;
use Data::Dumper;
use feature 'say';
use HTML::TableExtract;
use Mojo::DOM;
use Encode;


for my $f (glob "source_page/*.html"){
#for my $f (glob "source_page/10??.html"){
#for my $f (glob "source_page/1042.html"){
	say "======================$f======================";
	my $content;
	open F,$f;
	while(<F>){
		s/[\r\n]//g;
		$content .= $_;
	}
	close F;
	if($content =~ m#审核涉嫌侵权#){
		next;
	}
	my ($msg_title,$msg_desc) = parse_head($content);
	my ($desc) = $content =~ m#1.<span style="line-height: normal;(.*)2.<span style="font-size: 9px#;
	unless($desc){
		($desc) = $content =~ m#1.<span style="font-size: 9px(.*)2.<span style="font-size:#;
	}
	unless($desc){
		say join "\t",($msg_title,$msg_desc,remove_tag(parse_div($content)),'-','-','-','-','-');
		next;
	}
	$desc = remove_tag($desc);
	my ($purpose) = $content =~ m#2.<span style="font-size: 9px(.*)3.<span style="font-size: 9px#;
	$purpose = remove_tag($purpose);
	my ($design) = $content =~ m#3.<span style="font-size: 9px(.*)4.<span style="font-size: 9px#;
	$design = remove_tag($design);
	my ($standard) = $content =~ m#4.<span style="font-size: 9px(.*)5.<span style="font-size: 9px#;
	$standard = remove_tag($standard);
	if($standard =~ m|排除标准|){
		#说明作者写错了
		($standard) = $content =~ m#4.<span style="font-size: 9px(.*)5. </span><span style="font-size:#;
		$standard = remove_tag($standard);
		if($standard eq '-'){
			($standard) = $content =~ m#4. 入选标准(.*)4.<span style="font-size#;
			$standard = remove_tag($standard);
		}
	}
	my ($exclude) = $content =~ m#5.<span style="font-size: 9px(.*)6.<span style="font-size: 9px;#;
	unless($exclude){
		($exclude) = $content =~ m#5. </span><span style="font-size:(.*)5.<span style="font-size: 9px#;
	}
	unless($exclude){
		($exclude) = $content =~ m#4.<span style="font-size(.*)5.<span style="font-size:#;
	}
	$exclude = remove_tag($exclude);
	my $admin = parse_table($content);
	say join "\t",($msg_title,$msg_desc,$desc,$purpose,$design,$standard,$exclude,$admin);
}


sub remove_tag{
	my $raw = shift @_;
	return '-' unless $raw;
	$raw =~ s/<[^>]*>//gs;
	$raw =~ s#试验分期#\\n试验分期#;
	$raw =~ s#设计类型#\\n设计类型#;
	$raw =~ s#随机化#\\n随机化#;
	$raw =~ s#盲法#\\n盲法#;
	$raw =~ s#试验范围#\\n试验范围#;
	$raw =~ s#入组人数#\\n入组人数#;
	$raw =~ s#;line-height:normal;">##;
	$raw =~ s#；#；\\n#;
	$raw =~ s/\&nbsp;//gs;
	$raw =~ s/&nbsp; //gs;
	$raw =~ s/&gt/>/gs;
	$raw =~ s/\s//gs;
	$raw =~ s/\d\.$//;
	$raw;
}

sub parse_table{
    my $content = shift @_;
	my $output;
    my $te = new HTML::TableExtract();
    $te->parse( $content );
    for my $ts ($te -> table_states){
        for my $row ($ts->rows) {
			@$row = grep {$_} @$row;
            $output .= join "|",@$row;
            $output .= "\\n";
        }
    }
    $output =~ s#\s##g;
	$output;
}

sub parse_head{
	my ($msg_title) = $_[0] =~ m#var msg_title = "([^\"]+)";#;
	my ($msg_desc) = $_[0] =~ m#var msg_desc = "([^"]+)";#;
	$msg_title,$msg_desc;
}

sub parse_div{
	my $cp = $_[0];
	$cp =~ s#&nbsp;##g;
	my $dom = Mojo::DOM->new($cp);
	my $res = $dom->at('#js_content');
	$res
}
