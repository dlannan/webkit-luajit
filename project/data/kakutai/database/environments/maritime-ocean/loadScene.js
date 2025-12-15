var removenodes = [];

function postload(loadnode) {

    for (var i = 0; i < removenodes.length; i++) {
        var node = removenodes[i];
        node.parent.remove(node);
    }
}

function pernode(node) {

    // if ( node.material ) { 

    //     if(!node.material.name)
    //         return;
    // }

    if (node.name.indexOf("ocean-surface") > -1) {

        node.visible = false;

        var waterNormals = new THREE.TextureLoader().load('file:///database/environments/maritime-ocean/Waterbump.png', function(texture) {
            texture.wrapS = texture.wrapT = THREE.RepeatWrapping;
        });

        //node.visible = false;
        // var refractionMap = new THREE.TextureLoader().load( '/user/pages/assets/environments/maritime-ocean/grid.png', function ( texture ) {
        //     texture.wrapS = texture.wrapT = THREE.ClampToEdgeWrapping;
        // });

        // var heightMap = new THREE.TextureLoader().load( '/user/pages/assets/environments/maritime-ocean/depth.png', function ( texture ) {
        //     texture.wrapS = texture.wrapT = THREE.ClampToEdgeWrapping;
        // });

        // var floorMap = new THREE.TextureLoader().load( '/user/pages/assets/environments/maritime-ocean/sand.png', function ( texture ) {
        //      texture.wrapS = texture.wrapT = THREE.RepeatWrapping;
        // });

        var waterGeometry = new THREE.BoxBufferGeometry(4000, 4000, 300, 100, 100, 100);
        waterGeometry.translate(0, 0, -150.0);

        var oceanSurface = new THREE.WaterNice(
            waterGeometry, {
                textureWidth: 1024,
                textureHeight: 1024,
                waterNormals: waterNormals,
                //depthMap: heightMap,
                //refractionMap: refractionMap,
                alpha: 1.0,
                side: THREE.DoubleSide,
                sunDirection: dirLight.position.clone().normalize(),
                sunColor: 0xffffff,
                fog: scene.fog !== undefined
            });

        oceanSurface.rotation.x = -Math.PI * 0.5;

        var parent = node.parent;
        parent.add(oceanSurface);
        oceanSurface.castShadow = false;

        // Store the ocean in a collection for access (materials etc)
        ocean["surface"] = oceanSurface;
        addNodeToRaycastPool(oceanSurface);
        removenodes.push(node);
    }

    if (node.name.indexOf("ocean-floor") > -1) {

        node.visible = false;

        // var floorMap = new THREE.TextureLoader().load( '/user/pages/assets/environments/maritime-ocean/sand.png', function ( texture ) {
        //     texture.wrapS = texture.wrapT = THREE.RepeatWrapping;
        // });

        //        var floorGeometry = new THREE.PlaneBufferGeometry( 4000, 4000, 200, 200 );
        //        floorGeometry.translate( 0, 0, -100);

        var geometry = new THREE.ConeBufferGeometry(2000, 150, 32, 20, true);

        // if(ocean.scene == undefined) ocean["scene"] = new THREE.Scene();
        // ocean["floor"] = oceanUnderwater(node, geometry);
        // ocean.floor.position.y = 0.0;

        ocean["floor"] = oceanUnderwater(node, geometry);
        ocean.floor.position.y = -75.0;
        ocean.floor.rotation.x = -Math.PI;
        ocean.floor.material.side = THREE.BackSide;

        removenodes.push(node);
    }
}


// Boat shader buoyancy
// vec3 boatRight, boatUp, boatForward;
// vec3 boatPosition;

// void ComputeBoatTransform( void )
// {
// 	vec3 samples[5];

// 	samples[0] = vec3(0,0, 0);
// 	samples[1] = vec3(0,0, .5);
// 	samples[2] = vec3(0,0,-.5);
// 	samples[3] = vec3( .5,0,0);
// 	samples[4] = vec3(-.5,0,0);

// 	samples[0].y = WavesSmooth(samples[0]);
// 	samples[1].y = WavesSmooth(samples[1]);
// 	samples[2].y = WavesSmooth(samples[2]);
// 	samples[3].y = WavesSmooth(samples[3]);
// 	samples[4].y = WavesSmooth(samples[4]);

// 	boatPosition = (samples[0]+samples[1]+samples[2]+samples[3]+samples[4])/5.0;

// 	boatRight = samples[3]-samples[4];
// 	boatForward = samples[1]-samples[2];
// 	boatUp = normalize(cross(boatForward,boatRight));
// 	boatRight = normalize(cross(boatUp,boatForward));
// 	boatForward = normalize(boatForward);

// 	boatPosition += .0*boatUp;
// }