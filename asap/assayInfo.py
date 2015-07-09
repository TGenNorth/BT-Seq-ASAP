'''
Created on Jun 4, 2015

@author: dlemmer
'''

ASSAY_TYPES = ("presence/absence", "SNP", "gene variant", "ROI")

TARGET_FUNCTIONS = ("species ID", "strain ID", "resistance type", "virulence factor")

class Assay(object):
    '''
    classdocs
    '''

    def __init__(self, name, assay_type, target=None, AND=None):
        '''
        Constructor
        '''
        self.name = name
        self.assay_type = assay_type
        self.target = target
        self.AND = AND
    
    def __str__(self):
        return "Assay: %s (%s) \n{\n%s}\n" % (self.name, self.assay_type, self.target)
    
    @property
    def assay_type(self):
        return self._assay_type
    
    @assay_type.setter
    def assay_type(self, value):
        if value and value not in ASSAY_TYPES:
            raise TypeError('Not a valid Assay Type')
        self._assay_type = value
    
    @property
    def target(self):
        return self._target
    
    @target.setter        
    def target(self, value):
        if value and not isinstance(value, Target):
            raise TypeError('Not a valid Target')
        self._target = value
        
    @property
    def AND(self):
        return self._AND
    
    @AND.setter        
    def AND(self, value):
        if value and not isinstance(value, AND):
            raise TypeError('Not a valid AND operation')
        self._AND = value
        
class Target(object):
    '''
    classdocs
    '''

    def __init__(self, function, gene_name=None, start_position=None, end_position=None, reverse_comp=False, amplicon=None):
        '''
        Constructor
        '''
        self.function = function
        self.gene_name = gene_name
        self.start_position = start_position
        self.end_position = end_position
        self.reverse_comp = reverse_comp
        self.amplicons = []
        if amplicon:
            if isinstance(amplicon, list):
                for amp in amplicon:
                    self.add_amplicon(amp)
            else:
                self.add_amplicon(amplicon)

    def __str__(self):
        output = "Target: %s" % self.function
        if self.gene_name:
            output += " (%s" % self.gene_name
            if self.start_position:
                direction = "<-" if self.reverse_comp else "->" 
                output += " (:%d-%d %s" % (self.start_position, self.end_position, direction)
            output += ")"
        for amplicon in self.amplicons:
            output += "\n\t%s" % amplicon
        return output
    
    @property
    def function(self):
        return self._function
    
    @function.setter
    def function(self, value):
        if value and value not in TARGET_FUNCTIONS:
            raise TypeError('Not a valid Target Function')
        self._function = value
            
    def add_amplicon(self, amplicon):
        if not isinstance(amplicon, Amplicon):
            raise TypeError('Not a valid Amplicon')
        self.amplicons.append(amplicon)
        
class Amplicon(object):
    '''
    classdocs
    '''

    def __init__(self, sequence, variant_name=None, significance=None, snp=None, regionofinterest=None, AND=None):
        '''
        Constructor
        '''
        self.sequence = sequence
        self.variant_name = variant_name
        self.significance = significance
        self.SNPs = []
        self.ROIs = []
        self.AND = AND
        if snp:
            if isinstance(snp, list):
                for each_snp in snp:
                    self.add_SNP(each_snp)
            else:
                self.add_SNP(snp)
        if regionofinterest:
            if isinstance(regionofinterest, list):
                for roi in regionofinterest:
                    self.add_ROI(roi)
            else:
                self.add_ROI(regionofinterest)
            
    def __str__(self):
        output = "Amplicon: "
        if self.variant_name:
            output += "%s = %s\n" % (self.variant_name, self.significance)
        else:
            output += "{"
            for snp in self.SNPs:
                output += "%s, " % snp
            for roi in self.ROIs:
                output += "%s, " % roi
            if self.AND:
                output += "%s" % self.AND
            output += "}\n"
        return output    
    
    @property
    def significance(self):
        return self._significance
    
    @significance.setter
    def significance(self, value):
        if value and not isinstance(value, Significance):
            raise TypeError('Not a valid Significance')
        self._significance = value
        
    def add_SNP(self, snp):
        if not isinstance(snp, SNP):
            raise TypeError('Not a valid SNP')
        self.SNPs.append(snp)
        
    def add_ROI(self, roi):
        if not isinstance(roi, RegionOfInterest):
            raise TypeError('Not a valid RegionOfInterest')
        self.ROIs.append(roi)
        
    @property
    def AND(self):
        return self._AND
    
    @AND.setter        
    def AND(self, value):
        if value and not isinstance(value, AND):
            raise TypeError('Not a valid AND operation')
        self._AND = value
        
class SNP(object):
    '''
    classdocs
    '''

    def __init__(self, position, reference, variant, significance=None):
        '''
        Constructor
        '''
        self.position = position
        self.reference = reference
        self.variant = variant
        self.significance = significance
        
    def __str__(self):
        return "SNP: %d%s->%s = %s" % (self.position, self.reference, self.variant, self.significance)
        
    @property
    def significance(self):
        return self._significance
    
    @significance.setter
    def significance(self, value):
        if value and not isinstance(value, Significance):
            raise TypeError('Not a valid Significance')
        self._significance = value
        
class RegionOfInterest(object):
    '''
    classdocs
    '''

    def __init__(self, position_range, aa_sequence=None, significance=None):
        '''
        Constructor
        '''
        self.position_range = position_range
        self.aa_sequence = aa_sequence
        self.significance = significance
        
    @property
    def significance(self):
        return self._significance
    
    @significance.setter
    def significance(self, value):
        if value and not isinstance(value, Significance):
            raise TypeError('Not a valid Significance')
        self._significance = value
        
class Significance(object):
    '''
    classdocs
    '''

    def __init__(self, message):
        '''
        Constructor
        '''
        self.message = message
        
    def __str__(self):
        return "Significance: %s" % self.message
        
class AND(object):
    '''
    classdocs
    '''

    def __init__(self, significance, target=None, snp=None, regionofinterest=None):
        '''
        Constructor
        '''
        self.significance = significance
        self.operands = []
        if target:
            if isinstance(target, list):
                for each_target in target:
                    self.add_operand(each_target)
            else:
                self.add_operand(target)
        if snp:
            if isinstance(snp, list):
                for each_snp in snp:
                    self.add_operand(each_snp)
            else:
                self.add_operand(snp)
        if regionofinterest:
            if isinstance(regionofinterest, list):
                for roi in regionofinterest:
                    self.add_operand(roi)
            else:
                self.add_operand(regionofinterest)
    
    def __str__(self):
        return "AND: {" + ", ".join(map(str, self.operands)) + "} = %s" % self.significance          
        
    @property
    def significance(self):
        return self._significance
    
    @significance.setter
    def significance(self, value):
        if value and not isinstance(value, Significance):
            raise TypeError('Not a valid Significance')
        self._significance = value

    def add_operand(self, value):
        if not (isinstance(value, Target) or isinstance(value, SNP) or isinstance(value, RegionOfInterest)):
            raise TypeError('Not a valid operand')
        self.operands.append(value)
        

def _json_decode(json_dict):
    #print("json_dict = %s" % json_dict)
    json_dict = dict((k.lower() if k != 'AND' else 'AND', v) for k,v in json_dict.items())
    if "message" in json_dict:
        return Significance(**json_dict)
    elif "position_range" in json_dict:
        return RegionOfInterest(**json_dict)
    elif "position" in json_dict:
        return SNP(**json_dict)
    elif "sequence" in json_dict:
        return Amplicon(**json_dict)
    elif "function" in json_dict:
        return Target(**json_dict)
    elif "name" in json_dict:
        return Assay(**json_dict)
    elif "snp" in json_dict or "regionofinterest" in json_dict or "target" in json_dict:
        return AND(**json_dict)
    else:
        return json_dict
    
def parseJSON(filename):
    import json
    with open(filename) as json_fh:
        assay_data = json.load(json_fh, object_hook=_json_decode)
        return assay_data['assay']
    
def generateReference(assay_list):
    pass
        
def main():
    assays = parse_json('../TB.json')
    for assay in assays:
        print(assay)

if __name__ == "__main__":
    main()
