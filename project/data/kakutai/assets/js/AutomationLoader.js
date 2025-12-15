/**
 * Loader for Automation the steam game (exported zip)
 *	https://www.automationgame.com/
 *
 * Export contains Collada and BeamNG files which are decoded.
 */

AutomationLoader = function () {};

function typedArrayToBuffer(array) {
    return array.buffer.slice(array.byteOffset, array.byteLength + array.byteOffset);
}

function d2r(degrees)
{
  var pi = Math.PI;
  return degrees * (pi/180);
}

function baseName(str, noext)
{
   var base = new String(str).substring(str.lastIndexOf('/') + 1); 
    if(noext && base.lastIndexOf(".") != -1)       
        base = base.substring(0, base.lastIndexOf("."));
   return base;
}

function findByProp(o, prop) {
    if(o==null) return false;
    if( o[prop] ){
        return o[prop];
    }
    var result, p; 
    for (p in o) {
       if( o.hasOwnProperty(p) && typeof o[p] === 'object' ) {
           result = findByProp(o[p], prop);
           if(result) return result;
       }
    }
    return result;
}

function jsonFixer(json) {

    // Remove comments
    json = json.replace(/(\/\/.*?\n)/g, "");

    json = json.replace(/\](?=\s*?[\"])/g, "],");
    json = json.replace(/\}(?=\s*?[\"])/g, "},");
    json = json.replace(/\}(?=\s*?[\[])/g, "},");
    json = json.replace(/\}(?=\s*?[\{])/g, "},");
    json = json.replace(/\"(?=\s*?[\{])/g, "\",");

    json = json.replace(/\](?=\s*?[\[])/g, "],");
    json = json.replace(/\](?=\s*?[\{])/g, "],");
    json = json.replace(/\,(?=\s*?[\}\]])/g, "");
    json = json.replace(/\,(\s*?[\}\]])/g, "]");

    json = json.replace(/([\d\.]+\s*?)(\{)/g, "$1, {");

    json = json.replace(/(\,\s*\{\})/g, "");

    json = json.replace(/(":)([^\{\}\[\],]*?)(\n)(\s+?")/g, "$1$2,$3$4");

    json = json.replace(/(\")\s+?(\")/g, "$1, $2");
    json = json.replace(/(\d)\s+?(\")/g, "$1, $2");

    json = json.replace(/(\,\,)/g, ",");

    return json;
}

function GetMaterials( materialfile ) 
{
    if(materialfile == undefined) return {};

    var matstr = new TextDecoder("utf-8").decode(materialfile.buffer);
    var fields = matstr.split('singleton');
    var materials = {};

    fields.forEach( function(str, idx) {

        if(str.length > 1) {
        var matfunc = str.replace(/\=/g, ":");
        matfunc = matfunc.replace(/(\sMaterial)\((.*?)\)(\s*?\{[^\}]*?)/g, "{");
        matfunc = matfunc.replace(/\;/g, ",");
        matfunc = matfunc.replace(/\[(\d*?)\]/g, "$1");
        matfunc = matfunc.replace(/\s*?([\w\d]*?)\s*?(\:)/g,"\"$1\": ");
        matfunc = matfunc.replace(/(\}\,)/g, "}");
        matfunc = matfunc.replace(/\,(?=\s*?[\}\]])/g, "");

        // console.log(matfunc);        
        var tempobj = JSON.parse(matfunc);
        materials[tempobj.mapTo] = tempobj;
        }
    });
    return materials;
}

/*
 * Warning: The jbeam file format LOOKS like a json, but it is missing commas randomly (or appears so)
 *          which makes it difficult to use JSON.parse.
 * We extract only the sections we care about, rather than 'fixing' the whole file.
 */
function processJBeamFile( jbeamname, jbeamfile ) {
    
    var jsonstr = new TextDecoder("utf-8").decode(jbeamfile.buffer);
    var fixedjson = jsonFixer(jsonstr);
    //console.log(fixedjson);
    var jsonobj = JSON.parse(fixedjson);
    return jsonobj;
}

function loadZipModels(loader, modeltype) {

    if(!modeltype) modeltype = ".dae";
    var jbeamtype = ".jbeam";
    var texturetype = ".dds";
    var daefiles = [];
    var jbeamfiles = [];
    var textures = {};
    var materialfile;


    $.map(loader, function(v, i){
        if( i.includes(modeltype) ) daefiles.push(i);
        if( i.includes(jbeamtype) ) jbeamfiles.push(i);
        if( i.includes(texturetype) ) textures[baseName(i).toLowerCase()] = v;
        if( i.includes("materials.cs") ) materialfile = i;
    });

    console.log(textures);
    if(daefiles.length > 0) {
        console.log("Model found: ", daefiles);
    }
    else {
        return;
    }

    var res = daefiles[0];
    var jbeamdata = {};
    var transforms = {};

    if(jbeamfiles.length > 0) {
        console.log("JBeam files: ", jbeamfiles);

        var basename = res.replace(/\.[^.$]+$/, '');

        jbeamfiles.forEach( function( jfile ) {
            var basejfile = jfile.replace(/\.[^.$]+$/, '');
            var jbdata = processJBeamFile(basejfile, loader[jfile]);
            // if(basejfile == basename) {
                //console.log("JBeam Data: " + basejfile, jbdata);
                var bodies = findByProp( jbdata, "flexbodies" );
                if(bodies) {
                    bodies.forEach(function(val, idx) {

                        if(val.length > 3) {
                            transforms[val[0]] = val[3];
                        }
                    });
                }
            // }
            jbeamdata[basejfile] = jbdata;
        });
    }
    console.log(transforms);

    var modelformat = res.replace(/^.*\./, '');
    var model_data = {
        url: res,
        name: res,
        format: modelformat,
        parentType: "models",
        sourceData: loader[res]
    };

    clearThree(models);
    objects = [];
    objectsSearch = [];
    beamobjs = [];

    // Load the object
    loadLocalModel( model_data, function( model ) {

        //model.updateMatrixWorld(true);
        console.log(model);

        const box = new THREE.Box3().setFromObject(model);
        const boxSize = box.getSize(new THREE.Vector3());
        const boxCenter = box.getCenter(new THREE.Vector3());
        //console.log(boxSize);
        //console.log(boxCenter);

        var model_props = [
            {"propname":"Object Name", "propvalue": res}, 
            {"propname":"Bound Size", "propvalue": Vec3ToString(boxSize)}, 
            {"propname":"Bound Center", "propvalue": Vec3ToString(boxCenter)}
        ]; 
        console.log(model_props);
        updateProperties( model_props );

        //console.log("--> Model: ", model);

        models.add(model);

        onWindowResize();
        setTimeout(function() {


            if(materialfile)  {
                var automats = GetMaterials(loader[materialfile]);
                // Now we have the materials as an object. Load the diffuse files (as a test)
                console.log(automats);

                model.traverse( function( node ) {
                    if(node.material &&  node.isMesh) {
    
                        for(var i=0; i<node.material.length; i++) {
                            var pMat = node.material[i];
                            var amat = automats[pMat.name];
                            if(pMat.type == "MeshBasicMaterial") {

                                // var newMat = new THREE.MeshPhongMaterial();
                                // newMat.name = pMat.name;
                                // var autocolor = automats[pMat.name].materialTag2;
                                // if(pMat.name.includes("body")) {
                                //     console.log(node.name, pMat.name);
                                //     var keys = Object.keys(carmaterials);
                                //     var name = keys[getRandomInt(5, 17)];
                                //     node.material = carmaterials[name];
                                // }
                                // else {
                                    var newMat = getCarPaint(pMat.color);
                                    newMat.name = pMat.name;
                                    node.material[i] = newMat;
                                // }

                                if(amat.dynamicCubemap && amat.dynamicCubemap == true) {
                                    node.material[i].envMap = getEnvMap();
                                    node.material[i].envMapIntensity = 0.5;
                                }

                                if(amat.translucent == "1" && !amat.translucentBlendOp) {
                                    node.material[i].envMap = getSimpleEnvMap();
                                    node.material[i].envMapIntensity = 0.9;
                                    node.material[i].roughness = 0.0;
                                    node.material[i].reflectivity = 0.4;
                                    node.material[i].opacity = 0.9;
                                    node.material[i].transparent = true;
                                }

                                if(node.name.includes("wheel_f") || node.name.includes("wheel_r")) {
                                    node.material[i] = getMaterialByName('chrome');
                                    node.material[i].name = pMat.name;
                                }        

                                if(node.name.includes("tyre_f") || node.name.includes("tyre_r")) {
                                    node.material[i] = getMaterialByName('black-rough');
                                }        

                                // if(amat.reflectivityMap) {
                                //     var refmap = amat.reflectivityMap0.toLowerCase();
                                //     if(refmap.includes("glass")) {
                                //         node.material[i].envMap = new THREE.Texture();
                                //         var envtex = typedArrayToBuffer(textures[refmap]);
                                //         node.material[i].envMap.image = THREE.DDSLoader.parse(envtex);  
                                //     }
                                // }
                            }
                        }
                    }
                });

                model.traverse( function( node ) {
    
                    // Check positions
                    var beamtf = transforms[node.name];
                    if(beamtf && node.parent) {
                        beamobjs.push(node);
                    }
    
                    if(node.material && node.isMesh) {
        
                        for(var i=0; i<node.material.length; i++) {
                            var mat = node.material[i];
                            var amat = automats[mat.name];
                            //console.log(mat, amat);
                            if(amat && mat) {

                                if(amat.diffuseColor0) {
                                    var diffCol = amat.diffuseColor0.split(" ");
                                    mat.color.r = parseFloat(diffCol[0]);
                                    mat.color.g = parseFloat(diffCol[1]);
                                    mat.color.b = parseFloat(diffCol[2]);
                                    mat.color.a = parseFloat(diffCol[3]);
                                }

                                // if(mat.name.includes("body") && amat.materialTag2) {
                                //     mat.color = new THREE.Color(0x000077);
                                // }

                                // if(amat.specularColor0) {
                                //     var specCol = amat.specularColor0.split(" ");
                                //     mat.specularColor.r = parseFloat(specCol[0]);
                                //     mat.specularColor.g = parseFloat(specCol[1]);
                                //     mat.specularColor.b = parseFloat(specCol[2]);
                                //     mat.specularColor.a = parseFloat(specCol[3]);
                                // }

                                if(amat.diffuseMap0 && !(amat.diffuseMap0.includes("null"))) {
                                    mat.map = new THREE.Texture();
                                    var difftex = typedArrayToBuffer(textures[amat.diffuseMap0]);
                                    mat.map.image = THREE.DDSLoader.parse(difftex);
                                    // mat.map.needsUpdate = true;
                                    mat.map.src = amat.diffuseMap0;
                                    mat.map.minFilter = THREE.NearestFilter;
                                }

                                //mat.shininess = parseFloat(amat.specularPower0);

                                
                                // if(amat.translucent == "1" && !amat.translucentBlendOp) {
                                //     if(amat.opacityMap0 && !(amat.opacityMap0.includes("null"))) {
                                //     mat.alphaMap = new THREE.Texture();
                                //     var spectex = typedArrayToBuffer(textures[amat.opacityMap0]);
                                //     mat.alphaMap.image = THREE.DDSLoader.parse(spectex, false);
                                //     // mat.specularMap.needsUpdate = true;
                                //     mat.alphaMap.src = amat.opacityMap0;
                                //     mat.alphaMap.minFilter = THREE.NearestFilter;
                                //     }   
                                // }                             

                                // if(amat.specularMap0 && !(amat.specularMap0.includes("null"))) {
                                //     mat.specularMap = new THREE.Texture();
                                //     var spectex = typedArrayToBuffer(textures[amat.specularMap0]);
                                //     mat.specularMap.image = THREE.DDSLoader.parse(spectex, false);
                                //     // mat.specularMap.needsUpdate = true;
                                //     mat.specularMap.src = amat.specularMap0;
                                //     mat.specularMap.minFilter = THREE.NearestFilter;
                                // }

                                if(amat.doubleSided && amat.doubleSided == "1"){
                                    mat.side = THREE.DoubleSide;
                                    mat.shadowSide = THREE.BackSide;
                                }
                            }
                        }
                    }
                });
            }
    
            layoutLoaders.scenestate = 1;
            var pscl = new THREE.Vector3();        

            beamobjs.forEach(function(node, idx){
                    
                var beamtf = transforms[node.name];
                pscl.set(beamtf.pos.x, beamtf.pos.y, beamtf.pos.z);
                pscl = node.worldToLocal(pscl);

                var nodeparent = node.parent;
                node.rotation.set(d2r(beamtf.rot.x), d2r(beamtf.rot.y), d2r(beamtf.rot.z));
                node.position.set(pscl.x, pscl.z, -pscl.y);
                node.scale.set(beamtf.scale.x, beamtf.scale.y, beamtf.scale.z);

                if(node.name.includes("tyre_f") || node.name.includes("tyre_r") ||
                    node.name.includes("wheel_f") || node.name.includes("wheel_r")) {
                    var newnode = node.clone();
                    nodeparent.add(newnode);
                    newnode.position.set(-pscl.x, pscl.z, -pscl.y);
                    newnode.scale.set(-beamtf.scale.x, beamtf.scale.y, beamtf.scale.z);
                }
            });    

            var ent = SceneGraph.addMoverObject( model );

        }, 200);        
    });
}


AutomationLoader.prototype.load = function ( jsonUrl, callback, options ) {

	this.downloadModelZip( jsonUrl, callback, options );

};

AutomationLoader.prototype.downloadModelZip = function ( jsonUrl, callback, options ) {

    var req = new XMLHttpRequest();
    req.open("GET", jsonUrl, true);
    req.responseType = "arraybuffer";
    req.onload = function (event) {

        var unzipped = UZIP.parse(req.response);
        console.log("Downloaded:", unzipped);
        loadZipModels(unzipped);
    };

    req.send();
        
    // var loader = new ZipLoader( jsonUrl );   
    // loader.on( 'progress', function ( event ) {
    
    //   console.log( 'loading', event.loaded, event.total );
    // } );
    
    // loader.on( 'load', function ( event ) {
    
    //     console.log( 'loaded!' );
    //     console.log( loader.files );
    
    //     loadZipModels( loader );
    // } );
    
    // loader.on( 'error', function ( event ) {
    
    //   console.log( 'error', event.error );
    
    // } );
    
    // loader.load();
};

function addListeners( dom, listeners ) {

	// TODO: handle event capture, object binding.

	for ( var key in listeners ) {

		dom.addEventListener( key, listeners[ key ] );

	}

}
